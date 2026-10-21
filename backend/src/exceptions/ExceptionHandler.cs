using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;

namespace Clementbq.BattleTownship.Exceptions;

public class ExceptionHandler : IExceptionHandler
{
    public async ValueTask<bool> TryHandleAsync(
        HttpContext httpContext,
        Exception exception,
        CancellationToken cancellationToken)
    {
        if (exception is not BattleTownshipException)
            return false;

        var statusCode = exception switch
        {
            TownshipNotFoundException =>
                StatusCodes.Status404NotFound,

            _ => StatusCodes.Status400BadRequest
        };

        httpContext.Response.StatusCode = statusCode;

        await httpContext.Response.WriteAsJsonAsync(
            new ProblemDetails
            {
                Status = statusCode,
                Detail = exception.Message
            },
            cancellationToken
        );

        return true;
    }
}