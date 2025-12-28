using System;
using System.Collections.Generic;

namespace Clinic_Management.Models;

public partial class Appointment
{
    public int AppointmentId { get; set; }

    public int DoctorId { get; set; }

    public int PatientId { get; set; }

    public int StatusId { get; set; }

    public int CreatedByUserId { get; set; }

    public DateTime AppointmentStart { get; set; }

    public DateTime AppointmentEnd { get; set; }

    public string ReasonForVisit { get; set; } = null!;

    public string? Notes { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<AppointmentStatusHistory> AppointmentStatusHistories { get; set; } = new List<AppointmentStatusHistory>();

    public virtual User CreatedByUser { get; set; } = null!;

    public virtual Doctor Doctor { get; set; } = null!;

    public virtual Patient Patient { get; set; } = null!;

    public virtual AppointmentStatus Status { get; set; } = null!;
}
