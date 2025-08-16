using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace ConsoleApp3
{
    public abstract class Account
    {
        public string AccountNumber { get; set; }
        public decimal Balance { get; protected set; }
        public DateTime DateOpened { get; set; }
        public decimal InterestRate { get; private set; } = 0.05m; 

        public List<Transaction> TransactionHistory { get; set; } = new List<Transaction>();

        public Account()
        {
            AccountNumber = (Bank.AccountNumberCounter++).ToString();
            DateOpened = DateTime.Now;
        }

        public void Deposit(decimal amount)
        {
            if (amount <= 0)
            {
                Console.WriteLine("The amount must be greater than zero.");
                return;
            }
            Balance += amount;
            AddTransaction(new Transaction(amount, "Deposit"));
            Console.WriteLine($"Successfully deposited {amount:C}. New balance is: {Balance:C}");
        }

        public abstract bool Withdraw(decimal amount);

        public void AddTransaction(Transaction transaction)
        {
            TransactionHistory.Add(transaction);
        }
    }

}
