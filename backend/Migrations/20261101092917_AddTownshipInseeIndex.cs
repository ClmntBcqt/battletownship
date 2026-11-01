using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class AddTownshipInseeIndex : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "InseeCode",
                table: "Townships",
                type: "text",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Townships_InseeCode",
                table: "Townships",
                column: "InseeCode",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Townships_InseeCode",
                table: "Townships");

            migrationBuilder.DropColumn(
                name: "InseeCode",
                table: "Townships");
        }
    }
}
