using System;
using System.Collections.Generic;

class BankAccount
{
    public string AccountNumber { get; set; }
    public string AccountHolder { get; set; }
    public decimal Balance { get; set; }

    public virtual decimal CalculateInterest() => 0;

    public virtual void ShowAccountDetails()
    {
        Console.WriteLine($"Account Number: {AccountNumber}");
        Console.WriteLine($"Account Holder: {AccountHolder}");
        Console.WriteLine($"Balance: {Balance}");
    }
}

class SavingAccount : BankAccount
{
    public decimal InterestRate { get; set; }

    public override decimal CalculateInterest()
    {
        return Balance * InterestRate / 100;
    }

    public override void ShowAccountDetails()
    {
        base.ShowAccountDetails();
        Console.WriteLine($"Interest Rate: {InterestRate}%");
    }
}

class CurrentAccount : BankAccount
{
    public decimal OverdraftLimit { get; set; }

    public override decimal CalculateInterest()
    {
        return 0;
    }

    public override void ShowAccountDetails()
    {
        base.ShowAccountDetails();
        Console.WriteLine($"Overdraft Limit: {OverdraftLimit}");
    }
}

class Program
{
    static void Main()
    {
        var savingAcc = new SavingAccount
        {
            AccountNumber = "SA123",
            AccountHolder = "Ahmed",
            Balance = 10000,
            InterestRate = 5
        };

        var currentAcc = new CurrentAccount
        {
            AccountNumber = "CA456",
            AccountHolder = "Sara",
            Balance = 5000,
            OverdraftLimit = 2000
        };

        var accounts = new List<BankAccount> { savingAcc, currentAcc };

        foreach (var acc in accounts)
        {
            acc.ShowAccountDetails();
            Console.WriteLine($"Calculated Interest: {acc.CalculateInterest()}");
            Console.WriteLine();
        }
    }
}
