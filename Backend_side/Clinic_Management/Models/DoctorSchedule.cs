using System;
using System.Collections.Generic;

namespace Clinic_Management.Models;

public partial class DoctorSchedule
{
    public int ScheduleId { get; set; }

    public int DoctorId { get; set; }

    public int DayOfWeek { get; set; }

    public TimeOnly StartTime { get; set; }

    public TimeOnly EndTime { get; set; }

    public TimeOnly? BreakStartTime { get; set; }

    public TimeOnly? BreakEndTime { get; set; }

    public bool IsActive { get; set; }

    public DateTime? EffectiveFrom { get; set; }

    public DateTime? EffectiveTo { get; set; }

    public virtual Doctor Doctor { get; set; } = null!;
}
