using System;
using System.Collections.Generic;
using Clinic_Management.Models;
using Microsoft.EntityFrameworkCore;

namespace Clinic_Management.Data;

public partial class ClinicAppContext : DbContext
{
    public ClinicAppContext()
    {
    }

    public ClinicAppContext(DbContextOptions<ClinicAppContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Appointment> Appointments { get; set; }

    public virtual DbSet<AppointmentStatus> AppointmentStatuses { get; set; }

    public virtual DbSet<AppointmentStatusHistory> AppointmentStatusHistories { get; set; }

    public virtual DbSet<Doctor> Doctors { get; set; }

    public virtual DbSet<DoctorSchedule> DoctorSchedules { get; set; }

    public virtual DbSet<Patient> Patients { get; set; }

    public virtual DbSet<User> Users { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=DESKTOP-IVHRL9V;Initial Catalog=ClinicApp;Integrated Security=True;Encrypt=False;Trust Server Certificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Appointment>(entity =>
        {
            entity.HasKey(e => e.AppointmentId).HasName("PK_Appointments_AppointmentId");

            entity.Property(e => e.AppointmentEnd).HasColumnType("datetime");
            entity.Property(e => e.AppointmentStart).HasColumnType("datetime");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Notes).HasMaxLength(200);
            entity.Property(e => e.ReasonForVisit).HasMaxLength(200);
            entity.Property(e => e.UpdatedAt).HasColumnType("datetime");

            entity.HasOne(d => d.CreatedByUser).WithMany(p => p.Appointments)
                .HasForeignKey(d => d.CreatedByUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Appointments_CreatedByUserId");

            entity.HasOne(d => d.Doctor).WithMany(p => p.Appointments)
                .HasForeignKey(d => d.DoctorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Appointments_DoctorId");

            entity.HasOne(d => d.Patient).WithMany(p => p.Appointments)
                .HasForeignKey(d => d.PatientId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Appointments_PatientId");

            entity.HasOne(d => d.Status).WithMany(p => p.Appointments)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Appointments_StatusId");
        });

        modelBuilder.Entity<AppointmentStatus>(entity =>
        {
            entity.HasKey(e => e.StatusId).HasName("PK_AppointmentStatus_StatusId");

            entity.ToTable("AppointmentStatus");

            entity.HasIndex(e => e.StatusName, "UQ_AppointmentStatus_StatusName").IsUnique();

            entity.Property(e => e.StatusName).HasMaxLength(50);
        });

        modelBuilder.Entity<AppointmentStatusHistory>(entity =>
        {
            entity.HasKey(e => e.HistoryId).HasName("PK_AppointmentStatusHistory_HistoryId");

            entity.ToTable("AppointmentStatusHistory");

            entity.Property(e => e.ChangedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Appointment).WithMany(p => p.AppointmentStatusHistories)
                .HasForeignKey(d => d.AppointmentId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AppointmentStatusHistory_AppointmentId");

            entity.HasOne(d => d.ChangedByUser).WithMany(p => p.AppointmentStatusHistories)
                .HasForeignKey(d => d.ChangedByUserId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AppointmentStatusHistory_ChangedByUserId");

            entity.HasOne(d => d.NewStatus).WithMany(p => p.AppointmentStatusHistoryNewStatuses)
                .HasForeignKey(d => d.NewStatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AppointmentStatusHistory_NewStatusId");

            entity.HasOne(d => d.OldStatus).WithMany(p => p.AppointmentStatusHistoryOldStatuses)
                .HasForeignKey(d => d.OldStatusId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AppointmentStatusHistory_OldStatusId");
        });

        modelBuilder.Entity<Doctor>(entity =>
        {
            entity.HasKey(e => e.DoctorId).HasName("PK_Doctors_DoctorId");

            entity.HasIndex(e => e.Email, "UQ_Doctors_Email").IsUnique();

            entity.HasIndex(e => e.LicenseNumber, "UQ_Doctors_LicenseNumber").IsUnique();

            entity.HasIndex(e => e.UserId, "UQ_Doctors_UserId").IsUnique();

            entity.Property(e => e.Bio).HasMaxLength(500);
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DefaultAppointmentDurationMinutes).HasDefaultValue(20);
            entity.Property(e => e.Email).HasMaxLength(200);
            entity.Property(e => e.FirstName).HasMaxLength(100);
            entity.Property(e => e.LastName).HasMaxLength(150);
            entity.Property(e => e.LicenseNumber).HasMaxLength(100);
            entity.Property(e => e.Phone)
                .HasMaxLength(40)
                .IsUnicode(false);
            entity.Property(e => e.Specialization).HasMaxLength(150);
            entity.Property(e => e.UpdatedAt).HasColumnType("datetime");

            entity.HasOne(d => d.User).WithOne(p => p.Doctor)
                .HasForeignKey<Doctor>(d => d.UserId)
                .HasConstraintName("FK_Doctors_UserId");
        });

        modelBuilder.Entity<DoctorSchedule>(entity =>
        {
            entity.HasKey(e => e.ScheduleId).HasName("PK_DoctorSchedules_ScheduleId");

            entity.Property(e => e.BreakEndTime).HasPrecision(0);
            entity.Property(e => e.BreakStartTime).HasPrecision(0);
            entity.Property(e => e.EffectiveFrom).HasColumnType("datetime");
            entity.Property(e => e.EffectiveTo).HasColumnType("datetime");
            entity.Property(e => e.EndTime).HasPrecision(0);
            entity.Property(e => e.StartTime).HasPrecision(0);

            entity.HasOne(d => d.Doctor).WithMany(p => p.DoctorSchedules)
                .HasForeignKey(d => d.DoctorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("Fk_DoctorSchedules_DoctorId");
        });

        modelBuilder.Entity<Patient>(entity =>
        {
            entity.HasKey(e => e.PatientId).HasName("PK_Patients_PatientId");

            entity.HasIndex(e => e.PersonalIdNumber, "UQ_Patients_PersonalIdNumber").IsUnique();

            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.DateOfBirth).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(200);
            entity.Property(e => e.EmergencyContactName).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPhoneNumber).HasMaxLength(30);
            entity.Property(e => e.FirstName).HasMaxLength(100);
            entity.Property(e => e.Gender).HasMaxLength(50);
            entity.Property(e => e.LastName).HasMaxLength(150);
            entity.Property(e => e.Notes).HasMaxLength(300);
            entity.Property(e => e.PersonalIdNumber).HasMaxLength(30);
            entity.Property(e => e.Phone).HasMaxLength(30);
            entity.Property(e => e.UpdatedAt).HasColumnType("datetime");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK_Users_UserId");

            entity.HasIndex(e => e.UserName, "UQ_Users_UserName").IsUnique();

            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.LastLoginAt).HasColumnType("datetime");
            entity.Property(e => e.PasswordHash).HasMaxLength(300);
            entity.Property(e => e.Role).HasMaxLength(100);
            entity.Property(e => e.UserName).HasMaxLength(100);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
