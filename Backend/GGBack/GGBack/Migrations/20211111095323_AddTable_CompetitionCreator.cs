using Microsoft.EntityFrameworkCore.Migrations;

namespace GGBack.Migrations
{
    public partial class AddTable_CompetitionCreator : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "CompetitionCreators",
                columns: table => new
                {
                    CompetitionId = table.Column<int>(type: "int", nullable: false),
                    CreatorId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CompetitionCreators", x => new { x.CompetitionId, x.CreatorId });
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CompetitionCreators");
        }
    }
}
