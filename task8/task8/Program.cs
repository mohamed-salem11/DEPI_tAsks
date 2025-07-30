using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("Hello! Input the first number:");
        if (!int.TryParse(Console.ReadLine(), out int number1))
        {
            Console.WriteLine("Invalid input for the first number.");
            return;
        }

        Console.WriteLine("Input the second number:");
        if (!int.TryParse(Console.ReadLine(), out int number2))
        {
            Console.WriteLine("Invalid input for the second number.");
            return;
        }

        Console.WriteLine("What do you want to do with those numbers? [A]dd [S]ubtract [M]ultiply");
        string choice = Console.ReadLine()?.Trim().ToLower();

        switch (choice)
        {
            case "a":
                Console.WriteLine($"{number1} + {number2} = {number1 + number2}");
                break;
            case "s":
                Console.WriteLine($"{number1} - {number2} = {number1 - number2}");
                break;
            case "m":
                Console.WriteLine($"{number1} * {number2} = {number1 * number2}");
                break;
            default:
                Console.WriteLine("Invalid option");
                break;
        }

        Console.WriteLine("Press any key to close");
        Console.ReadKey();
    }
}
