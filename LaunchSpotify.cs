using System.Diagnostics;

class Program
{
    static void Main()
    {
        Process.Start(new ProcessStartInfo
        {
            FileName = "cmd.exe",
            Arguments = "/c start spotify:",
            CreateNoWindow = true,
            UseShellExecute = false
        });
    }
}
