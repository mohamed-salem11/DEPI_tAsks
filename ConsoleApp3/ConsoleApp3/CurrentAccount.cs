using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp3
{
    public class CurrentAccount : Account
    {
        public decimal OverdraftLimit { get; private set; } = 500m;

        public CurrentAccount(decimal initialDeposit)
        {
            Balance = initialDeposit;
        }

        public override bool Withdraw(decimal amount)
        {
            if (amount > Balance + OverdraftLimit)
            {
                Console.WriteLine("Overdraft limit exceeded.");
                return false;
            }
            Balance -= amount;
            AddTransaction(new Transaction(amount, "Withdrawal"));
            Console.WriteLine($"Successfully withdrew {amount:C}. New balance is: {Balance:C}");
            return true;
        }
    }

}


















