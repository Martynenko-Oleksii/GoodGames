using Microsoft.EntityFrameworkCore.Migrations;

namespace GGBack.Migrations
{
    public partial class CascadeDelete_RawNews : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_RawNewss_Competitions_CompetitionId",
                table: "RawNewss");

            migrationBuilder.AddForeignKey(
                name: "FK_RawNewss_Competitions_CompetitionId",
                table: "RawNewss",
                column: "CompetitionId",
                principalTable: "Competitions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_RawNewss_Competitions_CompetitionId",
                table: "RawNewss");

            migrationBuilder.AddForeignKey(
                name: "FK_RawNewss_Competitions_CompetitionId",
                table: "RawNewss",
                column: "CompetitionId",
                principalTable: "Competitions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
