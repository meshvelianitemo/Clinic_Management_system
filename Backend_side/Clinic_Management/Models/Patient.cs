using System;
using System.Collections.Generic;

namespace Clinic_Management.Models;

public partial class Patient
{
    public int PatientId { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public DateTime DateOfBirth { get; set; }

    public string Gender { get; set; } = null!;

    public string Phone { get; set; } = null!;

    public string? Email { get; set; }

    public string PersonalIdNumber { get; set; } = null!;

    public string? EmergencyContactName { get; set; }

    public string? EmergencyContactPhoneNumber { get; set; }

    public string? Notes { get; set; }

    public bool IsActive { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
}
