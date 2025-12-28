using System;
using System.Collections.Generic;

namespace Clinic_Management.Models;

public partial class User
{
    public int UserId { get; set; }

    public string UserName { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public string Role { get; set; } = null!;

    public bool IsActive { get; set; }

    public DateTime? LastLoginAt { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual ICollection<AppointmentStatusHistory> AppointmentStatusHistories { get; set; } = new List<AppointmentStatusHistory>();

    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();

    public virtual Doctor? Doctor { get; set; }
}
