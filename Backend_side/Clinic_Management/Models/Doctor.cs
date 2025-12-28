using System;
using System.Collections.Generic;

namespace Clinic_Management.Models;

public partial class Doctor
{
    public int DoctorId { get; set; }

    public int? UserId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string Specialization { get; set; } = null!;

    public string LicenseNumber { get; set; } = null!;

    public string Phone { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string? Bio { get; set; }

    public int? DefaultAppointmentDurationMinutes { get; set; }

    public DateTime? CreatedAt { get; set; }

    public bool IsActive { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    public virtual ICollection<DoctorSchedule> DoctorSchedules { get; set; } = new List<DoctorSchedule>();

    public virtual User? User { get; set; }
}
