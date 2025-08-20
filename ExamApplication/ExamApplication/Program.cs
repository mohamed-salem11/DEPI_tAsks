// Program.cs
using System;
using System.Collections.Generic;

namespace ExamApplication
{
    
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello, in exam system!");

            var questions = new List<Question>
            {
                new Question
                {
                    Text = "What is the capital of Egypt?",
                    Options = new List<string> { "1. Alexandria", "2. Cairo", "3. Luxor" },
                    CorrectAnswerIndex = 2
                },
                new Question
                {
                    Text = "What is the largest planet in the solar system?",
                    Options = new List<string> { "1. Jupiter", "2. Saturn", "3. Earth" },
                    CorrectAnswerIndex = 1
                },
                new Question
                {
                    Text = "What is the largest ocean in the world?",
                    Options = new List<string> { "1. Atlantic Ocean", "2. Indian Ocean", "3. Pacific Ocean" },
                    CorrectAnswerIndex = 3
                }
            };

            int score = 0;
            int totalQuestions = questions.Count;

            // Loop through each question
            for (int i = 0; i < totalQuestions; i++)
            {
                Console.WriteLine($"\nQuestion {i + 1}: {questions[i].Text}");

                // Display question options
                foreach (var option in questions[i].Options)
                {
                    Console.WriteLine(option);
                }

                // Get user's answer
                Console.Write("Enter the number of your correct answer: ");
                if (int.TryParse(Console.ReadLine(), out int userAnswer))
                {
                    // Check if the answer is correct
                    if (userAnswer == questions[i].CorrectAnswerIndex)
                    {
                        Console.WriteLine("Correct answer!");
                        score++;
                    }
                    else
                    {
                        Console.WriteLine("Wrong answer.");
                        Console.WriteLine($"The correct answer is: {questions[i].Options[questions[i].CorrectAnswerIndex - 1]}");
                    }
                }
                else
                {
                    // Handle invalid input
                    Console.WriteLine("Invalid input. Please enter a number.");
                }
            }

            // Display final score
            Console.WriteLine("\n--- Exam Over ---");
            Console.WriteLine($"You got {score} out of {totalQuestions} questions correct.");

            // Keep the console window open until the user presses a key
            Console.WriteLine("\nPress any key to exit...");
            Console.ReadKey();
        }
    }
}
