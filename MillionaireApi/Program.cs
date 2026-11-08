using System.Text.Json;
using Microsoft.Data.SqlClient;

var builder = WebApplication.CreateBuilder(args);
builder.WebHost.UseUrls("http://localhost:5080");
builder.Services.AddCors(o => o.AddDefaultPolicy(p => p.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod()));

var app = builder.Build();
app.UseCors();
app.UseStaticFiles(); // phục vụ ảnh cửa hàng trong thư mục wwwroot/store

// Có lỗi (ví dụ chưa kết nối được SQL Server) thì trả JSON có nội dung lỗi để dễ xem
app.Use(async (ctx, next) =>
{
    try { await next(); }
    catch (Exception ex)
    {
        Console.WriteLine(ex);
        ctx.Response.StatusCode = 500;
        await ctx.Response.WriteAsJsonAsync(new { message = ex.Message });
    }
});

var connStr = builder.Configuration.GetConnectionString("Default")
    ?? throw new InvalidOperationException("Thiếu ConnectionStrings:Default trong appsettings.json");

static object V(object? o) => o ?? DBNull.Value;

app.MapGet("/", () => "Millionaire API đang chạy");

// Mở trình duyệt vào http://localhost:5080/api/health để thử kết nối SQL Server
app.MapGet("/api/health", async () =>
{
    await using var conn = new SqlConnection(connStr);
    await conn.OpenAsync();
    return Results.Ok(new { ok = true });
});

// ---------------------------------------------------------------- CÂU HỎI

// Lấy ngẫu nhiên 1 câu CHƯA HỎI ở level này. Hết câu chưa hỏi -> reset riêng level đó rồi lấy lại.
app.MapGet("/api/questions/random", async (int level) =>
{
    if (level < 1 || level > 15) return Results.BadRequest(new { message = "level phải từ 1 đến 15" });

    await using var conn = new SqlConnection(connStr);
    await conn.OpenAsync();

    var q = await PickRandom(conn, level);
    if (q == null)
    {
        await using var reset = new SqlCommand("UPDATE dbo.Questions SET IsAsked = 0 WHERE [Level] = @l", conn);
        reset.Parameters.AddWithValue("@l", level);
        await reset.ExecuteNonQueryAsync();
        q = await PickRandom(conn, level);
    }
    return q == null
        ? Results.NotFound(new { message = $"Chưa có câu hỏi nào ở level {level}" })
        : Results.Ok(q);
});

// Game gọi khi câu hỏi thật sự đã hiện ra cho người chơi
app.MapPost("/api/questions/{id:int}/asked", async (int id) =>
{
    await using var conn = new SqlConnection(connStr);
    await conn.OpenAsync();
    await using var cmd = new SqlCommand(
        "UPDATE dbo.Questions SET IsAsked = 1, AskedCount = AskedCount + 1, LastAskedAt = SYSDATETIME() WHERE Id = @id", conn);
    cmd.Parameters.AddWithValue("@id", id);
    var n = await cmd.ExecuteNonQueryAsync();
    return n > 0 ? Results.Ok(new { id, asked = true }) : Results.NotFound(new { message = "Không có câu hỏi này" });
});

// Cho chơi lại từ đầu: POST /api/questions/reset (tất cả) hoặc /api/questions/reset?level=5
app.MapPost("/api/questions/reset", async (int? level) =>
{
    await using var conn = new SqlConnection(connStr);
    await conn.OpenAsync();
    await using var cmd = new SqlCommand(
        "UPDATE dbo.Questions SET IsAsked = 0 WHERE (@l IS NULL OR [Level] = @l)", conn);
    cmd.Parameters.AddWithValue("@l", V(level));
    var n = await cmd.ExecuteNonQueryAsync();
    return Results.Ok(new { reset = n });
});

// ---------------------------------------------------------------- XẾP HẠNG / NGƯỜI CHƠI

// type=day: chỉ người chơi hôm nay; type=all: tất cả. Sắp xếp theo điểm giảm dần.
app.MapGet("/api/ranking", async (string? type, int? limit) =>
{
    var onlyToday = string.Equals(type, "day", StringComparison.OrdinalIgnoreCase);
    var top = Math.Clamp(limit ?? 60, 1, 500);
    var sql = $@"SELECT TOP ({top}) PlayerName, Score, Image, DeviceId, BoughtItems, PlayDate
                 FROM dbo.Players
                 {(onlyToday ? "WHERE CAST(PlayDate AS date) = CAST(SYSDATETIME() AS date)" : "")}
                 ORDER BY Score DESC, PlayDate DESC";

    await using var conn = new SqlConnection(connStr);
    await conn.OpenAsync();
    await using var cmd = new SqlCommand(sql, conn);
    await using var r = await cmd.ExecuteReaderAsync();

    var list = new List<PlayerDto>();
    while (await r.ReadAsync()) list.Add(ReadPlayer(r));
    return Results.Ok(list);
});

// Lấy 1 người chơi theo tên (để đổi sang người chơi khác / quay lại người cũ)
app.MapGet("/api/players/one", async (string name) =>
{
    await using var conn = new SqlConnection(connStr);
    await conn.OpenAsync();
    await using var cmd = new SqlCommand(
        "SELECT PlayerName, Score, Image, DeviceId, BoughtItems, PlayDate FROM dbo.Players WHERE PlayerName = @name", conn);
    cmd.Parameters.AddWithValue("@name", name.Trim());
    await using var r = await cmd.ExecuteReaderAsync();
    return await r.ReadAsync()
        ? Results.Ok(ReadPlayer(r))
        : Results.NotFound(new { message = "Chưa có người chơi này" });
});

// Thêm mới hoặc cập nhật người chơi (theo tên). Score là tổng điểm hiện tại do game gửi lên.
app.MapPut("/api/players", async (PlayerUpsert p) =>
{
    var name = p.Name?.Trim();
    if (string.IsNullOrEmpty(name)) return Results.BadRequest(new { message = "Thiếu tên người chơi" });

    const string sql = @"
UPDATE dbo.Players
   SET Score = @score, Image = @img, DeviceId = @dev, BoughtItems = @bought, PlayDate = SYSDATETIME()
 WHERE PlayerName = @name;
IF @@ROWCOUNT = 0
    INSERT INTO dbo.Players (PlayerName, Score, Image, DeviceId, BoughtItems)
    VALUES (@name, @score, @img, @dev, @bought);";

    await using var conn = new SqlConnection(connStr);
    await conn.OpenAsync();
    await using var cmd = new SqlCommand(sql, conn);
    cmd.Parameters.AddWithValue("@name", name);
    cmd.Parameters.AddWithValue("@score", p.Score);
    cmd.Parameters.AddWithValue("@img", V(p.Image));
    cmd.Parameters.AddWithValue("@dev", V(p.DeviceId));
    cmd.Parameters.AddWithValue("@bought", V(p.BoughtItem == null ? null : JsonSerializer.Serialize(p.BoughtItem)));
    await cmd.ExecuteNonQueryAsync();
    return Results.Ok(new { name, score = p.Score });
});

// Xóa người chơi khỏi bảng xếp hạng: DELETE /api/players?name=...
app.MapDelete("/api/players", async (string name) =>
{
    await using var conn = new SqlConnection(connStr);
    await conn.OpenAsync();
    await using var cmd = new SqlCommand("DELETE FROM dbo.Players WHERE PlayerName = @name", conn);
    cmd.Parameters.AddWithValue("@name", name.Trim());
    var n = await cmd.ExecuteNonQueryAsync();
    return Results.Ok(new { deleted = n });
});

// ---------------------------------------------------------------- CỬA HÀNG

// Danh sách món theo nhóm. ImageFile là tên file trong wwwroot/store (hoặc link http đầy đủ).
app.MapGet("/api/store", async (HttpRequest req) =>
{
    var imgBase = $"{req.Scheme}://{req.Host}/store/files/";
    await using var conn = new SqlConnection(connStr);
    await conn.OpenAsync();
    await using var cmd = new SqlCommand(
        @"SELECT Category, Name, Price, ImageFile FROM dbo.StoreItems
          ORDER BY CategoryOrder, Category, SortOrder, Price", conn);
    await using var r = await cmd.ExecuteReaderAsync();

    var result = new List<StoreCategoryDto>();
    while (await r.ReadAsync())
    {
        var category = r.GetString(0);
        var file = r.GetString(3);
        var image = file.StartsWith("http", StringComparison.OrdinalIgnoreCase)
            ? file
            : imgBase + Uri.EscapeDataString(file);
        if (result.Count == 0 || result[^1].Category != category)
            result.Add(new StoreCategoryDto(category, new List<StoreItemDto>()));
        result[^1].Items.Add(new StoreItemDto(r.GetString(1), r.GetInt64(2), image));
    }
    return Results.Ok(result);
});

app.Run();

static PlayerDto ReadPlayer(SqlDataReader r)
{
    string[]? bought = r.IsDBNull(4) ? null : JsonSerializer.Deserialize<string[]>(r.GetString(4));
    return new PlayerDto(
        r.GetString(0),
        r.GetInt64(1),
        r.IsDBNull(2) ? null : r.GetString(2),
        r.IsDBNull(3) ? null : r.GetString(3),
        bought,
        r.GetDateTime(5));
}

static async Task<QuestionDto?> PickRandom(SqlConnection conn, int level)
{
    const string sql = @"SELECT TOP (1) Id, [Level], QuestionText, CaseA, CaseB, CaseC, CaseD, TrueCase
                         FROM dbo.Questions
                         WHERE [Level] = @l AND IsAsked = 0
                         ORDER BY NEWID()";
    await using var cmd = new SqlCommand(sql, conn);
    cmd.Parameters.AddWithValue("@l", level);
    await using var r = await cmd.ExecuteReaderAsync();
    if (!await r.ReadAsync()) return null;
    return new QuestionDto(
        r.GetInt32(0), r.GetByte(1), r.GetString(2),
        r.GetString(3), r.GetString(4), r.GetString(5), r.GetString(6), r.GetByte(7));
}

record QuestionDto(int Id, int Level, string Question, string CaseA, string CaseB, string CaseC, string CaseD, int TrueCase);
record PlayerDto(string Name, long Score, string? Image, string? DeviceId, string[]? BoughtItem, DateTime PlayDate);
record PlayerUpsert(string? Name, long Score, string? Image, string? DeviceId, string[]? BoughtItem);
record StoreItemDto(string Name, long Price, string Image);
record StoreCategoryDto(string Category, List<StoreItemDto> Items);