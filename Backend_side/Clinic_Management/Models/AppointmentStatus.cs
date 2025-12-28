using System;
using System.Collections.Generic;

namespace Clinic_Management.Models;

public partial class AppointmentStatus
{
    public int StatusId { get; set; }

    public string StatusName { get; set; } = null!;

    public bool IsFinal { get; set; }

    public bool IsActive { get; set; }

    public virtual ICollection<AppointmentStatusHistory> AppointmentStatusHistoryNewStatuses { get; set; } = new List<AppointmentStatusHistory>();

    public virtual ICollection<AppointmentStatusHistory> AppointmentStatusHistoryOldStatuses { get; set; } = new List<AppointmentStatusHistory>();

    public virtual ICollection<Appointment> Appointments { get; set; } = new List<Appointment>();
}
