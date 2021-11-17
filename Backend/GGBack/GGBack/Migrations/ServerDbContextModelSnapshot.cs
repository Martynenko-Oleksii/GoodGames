﻿// <auto-generated />
using System;
using GGBack.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace GGBack.Migrations
{
    [DbContext(typeof(ServerDbContext))]
    partial class ServerDbContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("Relational:MaxIdentifierLength", 128)
                .HasAnnotation("ProductVersion", "5.0.11")
                .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

            modelBuilder.Entity("CompetitionCompetitor", b =>
                {
                    b.Property<int>("CompetitionsId")
                        .HasColumnType("int");

                    b.Property<int>("CompetitorsId")
                        .HasColumnType("int");

                    b.HasKey("CompetitionsId", "CompetitorsId");

                    b.HasIndex("CompetitorsId");

                    b.ToTable("CompetitionCompetitor");
                });

            modelBuilder.Entity("CompetitionUser", b =>
                {
                    b.Property<int>("CompetitionsId")
                        .HasColumnType("int");

                    b.Property<int>("UsersId")
                        .HasColumnType("int");

                    b.HasKey("CompetitionsId", "UsersId");

                    b.HasIndex("UsersId");

                    b.ToTable("CompetitionUser");
                });

            modelBuilder.Entity("CompetitorTimetableCell", b =>
                {
                    b.Property<int>("CompetitorsId")
                        .HasColumnType("int");

                    b.Property<int>("TimetableCellsId")
                        .HasColumnType("int");

                    b.HasKey("CompetitorsId", "TimetableCellsId");

                    b.HasIndex("TimetableCellsId");

                    b.ToTable("CompetitorTimetableCell");
                });

            modelBuilder.Entity("GGBack.Models.Competition", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<string>("AgeLimit")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("City")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Description")
                        .HasColumnType("nvarchar(max)");

                    b.Property<DateTime>("EndDate")
                        .HasColumnType("datetime2");

                    b.Property<bool>("IsOpen")
                        .HasColumnType("bit");

                    b.Property<bool>("IsPublic")
                        .HasColumnType("bit");

                    b.Property<int?>("SportId")
                        .HasColumnType("int");

                    b.Property<DateTime>("StartDate")
                        .HasColumnType("datetime2");

                    b.Property<int>("State")
                        .HasColumnType("int");

                    b.Property<string>("StreamUrl")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Title")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.HasIndex("SportId");

                    b.ToTable("Competitions");
                });

            modelBuilder.Entity("GGBack.Models.CompetitionCreator", b =>
                {
                    b.Property<int>("CompetitionId")
                        .HasColumnType("int");

                    b.Property<int>("CreatorId")
                        .HasColumnType("int");

                    b.HasKey("CompetitionId", "CreatorId");

                    b.ToTable("CompetitionCreators");
                });

            modelBuilder.Entity("GGBack.Models.Competitor", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<int>("Age")
                        .HasColumnType("int");

                    b.Property<string>("Email")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Gender")
                        .IsRequired()
                        .HasColumnType("nvarchar(1)");

                    b.Property<string>("HealthState")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Name")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Team")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("Weigth")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.ToTable("Competitors");
                });

            modelBuilder.Entity("GGBack.Models.RawNews", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<string>("BodyData")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int?>("CompetitionId")
                        .HasColumnType("int");

                    b.Property<DateTime>("Date")
                        .HasColumnType("datetime2");

                    b.Property<string>("HeaderData")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("TemplatePath")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.HasIndex("CompetitionId");

                    b.ToTable("RawNewss");
                });

            modelBuilder.Entity("GGBack.Models.Sport", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<bool>("HasGrid")
                        .HasColumnType("bit");

                    b.Property<bool>("HasTeam")
                        .HasColumnType("bit");

                    b.Property<int>("MinCompetitorsCount")
                        .HasColumnType("int");

                    b.Property<int>("MinTeamsCount")
                        .HasColumnType("int");

                    b.Property<int>("TeamSize")
                        .HasColumnType("int");

                    b.Property<string>("Title")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("Sports");
                });

            modelBuilder.Entity("GGBack.Models.Subscription", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<DateTime>("End")
                        .HasColumnType("datetime2");

                    b.Property<int>("Level")
                        .HasColumnType("int");

                    b.Property<DateTime>("Start")
                        .HasColumnType("datetime2");

                    b.HasKey("Id");

                    b.ToTable("Subscriptions");
                });

            modelBuilder.Entity("GGBack.Models.TimetableCell", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<int?>("CompetitionId")
                        .HasColumnType("int");

                    b.Property<DateTime>("DateTime")
                        .HasColumnType("datetime2");

                    b.Property<int>("GridStage")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("CompetitionId");

                    b.ToTable("TimetableCells");
                });

            modelBuilder.Entity("GGBack.Models.User", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<string>("AvatarPath")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("DeviceToken")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Email")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Login")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Password")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int?>("SubscriptionId")
                        .HasColumnType("int");

                    b.Property<string>("Token")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.HasIndex("SubscriptionId");

                    b.ToTable("Users");
                });

            modelBuilder.Entity("GGBack.Models.WinResult", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int")
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<string>("Score")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("TeamOne")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("TeamTwo")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("TimetableCellId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("TimetableCellId")
                        .IsUnique();

                    b.ToTable("WinResults");
                });

            modelBuilder.Entity("SportUser", b =>
                {
                    b.Property<int>("SportsId")
                        .HasColumnType("int");

                    b.Property<int>("UsersId")
                        .HasColumnType("int");

                    b.HasKey("SportsId", "UsersId");

                    b.HasIndex("UsersId");

                    b.ToTable("SportUser");
                });

            modelBuilder.Entity("CompetitionCompetitor", b =>
                {
                    b.HasOne("GGBack.Models.Competition", null)
                        .WithMany()
                        .HasForeignKey("CompetitionsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("GGBack.Models.Competitor", null)
                        .WithMany()
                        .HasForeignKey("CompetitorsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("CompetitionUser", b =>
                {
                    b.HasOne("GGBack.Models.Competition", null)
                        .WithMany()
                        .HasForeignKey("CompetitionsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("GGBack.Models.User", null)
                        .WithMany()
                        .HasForeignKey("UsersId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("CompetitorTimetableCell", b =>
                {
                    b.HasOne("GGBack.Models.Competitor", null)
                        .WithMany()
                        .HasForeignKey("CompetitorsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("GGBack.Models.TimetableCell", null)
                        .WithMany()
                        .HasForeignKey("TimetableCellsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("GGBack.Models.Competition", b =>
                {
                    b.HasOne("GGBack.Models.Sport", "Sport")
                        .WithMany()
                        .HasForeignKey("SportId");

                    b.Navigation("Sport");
                });

            modelBuilder.Entity("GGBack.Models.RawNews", b =>
                {
                    b.HasOne("GGBack.Models.Competition", "Competition")
                        .WithMany("RawNewss")
                        .HasForeignKey("CompetitionId")
                        .OnDelete(DeleteBehavior.Cascade);

                    b.Navigation("Competition");
                });

            modelBuilder.Entity("GGBack.Models.TimetableCell", b =>
                {
                    b.HasOne("GGBack.Models.Competition", "Competition")
                        .WithMany("TimetableCells")
                        .HasForeignKey("CompetitionId")
                        .OnDelete(DeleteBehavior.Cascade);

                    b.Navigation("Competition");
                });

            modelBuilder.Entity("GGBack.Models.User", b =>
                {
                    b.HasOne("GGBack.Models.Subscription", "Subscription")
                        .WithMany("Users")
                        .HasForeignKey("SubscriptionId");

                    b.Navigation("Subscription");
                });

            modelBuilder.Entity("GGBack.Models.WinResult", b =>
                {
                    b.HasOne("GGBack.Models.TimetableCell", "TimetableCell")
                        .WithOne("WinResult")
                        .HasForeignKey("GGBack.Models.WinResult", "TimetableCellId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("TimetableCell");
                });

            modelBuilder.Entity("SportUser", b =>
                {
                    b.HasOne("GGBack.Models.Sport", null)
                        .WithMany()
                        .HasForeignKey("SportsId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("GGBack.Models.User", null)
                        .WithMany()
                        .HasForeignKey("UsersId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("GGBack.Models.Competition", b =>
                {
                    b.Navigation("RawNewss");

                    b.Navigation("TimetableCells");
                });

            modelBuilder.Entity("GGBack.Models.Subscription", b =>
                {
                    b.Navigation("Users");
                });

            modelBuilder.Entity("GGBack.Models.TimetableCell", b =>
                {
                    b.Navigation("WinResult");
                });
#pragma warning restore 612, 618
        }
    }
}
