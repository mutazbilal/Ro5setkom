namespace ro5setkom.Utils.Validation;
using System.ComponentModel.DataAnnotations;

public class MustBeTrueAttribute : ValidationAttribute
{
    public override bool IsValid(object value)
    {
        // Enforce that the value is a boolean and is specifically true
        return value is bool b && b;
    }
}