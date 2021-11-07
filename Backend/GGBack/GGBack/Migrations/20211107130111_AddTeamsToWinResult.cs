using Microsoft.EntityFrameworkCore.Migrations;

namespace GGBack.Migrations
{
    public partial class AddTeamsToWinResult : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "TeamOne",
                table: "WinResults",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "TeamTwo",
                table: "WinResults",
                type: "nvarchar(max)",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "TeamOne",
                table: "WinResults");

            migrationBuilder.DropColumn(
                name: "TeamTwo",
                table: "WinResults");
        }
    }
}
