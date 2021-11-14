using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace GGBack.Migrations
{
    public partial class SetCascadeDelete_Competitions : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_TimetableCells_Competitions_CompetitionId",
                table: "TimetableCells");

            migrationBuilder.DropForeignKey(
                name: "FK_TimetableCells_WinResults_WinResultId",
                table: "TimetableCells");

            migrationBuilder.DropIndex(
                name: "IX_TimetableCells_WinResultId",
                table: "TimetableCells");

            migrationBuilder.DropColumn(
                name: "WinResultId",
                table: "TimetableCells");

            migrationBuilder.AddColumn<int>(
                name: "TimetableCellId",
                table: "WinResults",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "RawNewss",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    HeaderData = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    BodyData = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    TemplatePath = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Date = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CompetitionId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_RawNewss", x => x.Id);
                    table.ForeignKey(
                        name: "FK_RawNewss_Competitions_CompetitionId",
                        column: x => x.CompetitionId,
                        principalTable: "Competitions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_WinResults_TimetableCellId",
                table: "WinResults",
                column: "TimetableCellId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_RawNewss_CompetitionId",
                table: "RawNewss",
                column: "CompetitionId");

            migrationBuilder.AddForeignKey(
                name: "FK_TimetableCells_Competitions_CompetitionId",
                table: "TimetableCells",
                column: "CompetitionId",
                principalTable: "Competitions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_WinResults_TimetableCells_TimetableCellId",
                table: "WinResults",
                column: "TimetableCellId",
                principalTable: "TimetableCells",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_TimetableCells_Competitions_CompetitionId",
                table: "TimetableCells");

            migrationBuilder.DropForeignKey(
                name: "FK_WinResults_TimetableCells_TimetableCellId",
                table: "WinResults");

            migrationBuilder.DropTable(
                name: "RawNewss");

            migrationBuilder.DropIndex(
                name: "IX_WinResults_TimetableCellId",
                table: "WinResults");

            migrationBuilder.DropColumn(
                name: "TimetableCellId",
                table: "WinResults");

            migrationBuilder.AddColumn<int>(
                name: "WinResultId",
                table: "TimetableCells",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_TimetableCells_WinResultId",
                table: "TimetableCells",
                column: "WinResultId");

            migrationBuilder.AddForeignKey(
                name: "FK_TimetableCells_Competitions_CompetitionId",
                table: "TimetableCells",
                column: "CompetitionId",
                principalTable: "Competitions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_TimetableCells_WinResults_WinResultId",
                table: "TimetableCells",
                column: "WinResultId",
                principalTable: "WinResults",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
