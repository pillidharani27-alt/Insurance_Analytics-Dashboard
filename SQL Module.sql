create database insurence;
use insurence;
select * from brokerage;
select * from fees;
select * from `individual budgets`;
select * from invoice;
select * from meeting;
select * from opportunity;
show tables;

# Targets FY from Individual Budgets
select sum(New_Budget) as New_Budget, sum(Cross_sell_bugdet) as Cross_Sell_Budget, sum(Renewal_Budget) as Renewal_Budget from `individual budgets`;

# invoices Achievement
select Account_Executive, Branch_Name, Income_Class, sum(Amount) as Total_Invoice_Amount from invoice group by Account_Executive, branch_name, income_class
order by income_class desc , total_invoice_amount desc;

# Placed Achievement (New, Cross Sell, Renewal):
select Income_Class,
    round((select sum(amount) from brokerage where income_class = b.income_class),2) +
    round((select sum(amount) from fees where income_class = b.income_class),2) 
    as Placed_Achievement from brokerage b
where income_class in ('New', 'Cross Sell', 'Renewal') group by income_class;

# 1-No of Invoice by Accnt Exec
select account_executive, income_class, count(income_class) as No_of_Invoice from invoice group by income_class,account_executive 
order by income_class desc,no_of_invoice desc;

#  2-Yearly Meeting Count
select year(meeting_date) as Year, count(year(meeting_date)) as Meetings  from meeting group by year(meeting_date);

# 4. Stage Funnel by Revenue
select Stage,sum(revenue_amount) as Revenue_Amount from opportunity group by stage;

# 3.Cross Sell → Target, Achieved, Invoice

# ********** cross sell(Target) **********
select sum(cross_sell_bugdet) as Target from `individual budgets`;

# ********** cross sell(Achieved) **********
select (select sum(Amount) from brokerage where income_class = 'Cross Sell') +  sum(Amount)as Achieved,Income_Class from fees 
where income_class = 'Cross Sell' group by income_class;

# ********** Cross sell(Invoice) **********
select Income_Class, sum(Amount) as Invoice from invoice where income_class = 'Cross Sell' group by income_class;

# New → Target, Achieved, Invoice

# ********** New(Target) **********
select sum(New_Budget) as Target from `individual budgets`;

# ********** new(Achieve) ********** 
select round((select sum(Amount)from brokerage where income_class = 'New'),2) + sum(Amount) as Achieved,Income_Class from fees 
where income_class = 'New' group by income_class;

# ********** new(Invoice) ********** 
select Income_Class, sum(Amount) as Invoice from invoice where income_class = 'New' group by income_class;

# Renewal → Target, Achieved, Invoice

# ********** Renewal(target) ********** 
select sum(renewal_budget) as Target from `individual budgets`;

# ********** Renewal(Achieved) ********** 
select round((select sum(Amount) from brokerage where income_class = 'Renewal'),2) + sum(Amount) as Achieved,income_class from fees 
where income_class = 'Renewal' group by income_class;

# ********** Renewal(Invoice) ********** 
select Income_Class, sum(Amount) as Invoice from invoice where income_class = 'Renewal' group by income_class;

# Cross_Sell_Placed_Ach %
select 'cross sell' as Income_Class ,
concat(round(((select sum(Amount) from brokerage where income_class = 'Cross Sell') + (select sum(Amount) from fees where income_class = 'Cross Sell'))
/ (select sum(Cross_sell_bugdet) from `individual budgets`) * 100, 2),' %') as 'Cross_Sell_Placed_Ach %';
 
 # Cross_Sell_Invoice_Ach %
select 'cross sell'as Income_Class, 
concat(round((select sum(Amount) from invoice where income_class = 'Cross Sell')
/ (select sum(Cross_sell_bugdet) from `individual budgets`) * 100, 2),' %') as 'Cross_Sell_Invoice_Ach %';
  
# New_Placed_Ach %
select 'new' as Income_Class, 
concat(round(((select sum(Amount) from brokerage where income_class = 'New') + (select sum(Amount) from fees where income_class = 'New'))
/ (select sum(New_Budget) from `individual budgets`) * 100, 2),' %') as 'New_Placed_Ach %';
 
# New_Placed_Ach %
SELECT 'new' as Income_Class, 
concat(round((select sum(Amount) from invoice where income_class = 'New')
/ (select sum(New_Budget) from `individual budgets`) * 100, 2),' %') as 'New_Placed_Ach %';
 
# Renewal_Placed_Ach %
select 'renweal' as Income_Class, 
concat(round(((select sum(Amount) from brokerage where income_class = 'Renewal') + (select sum(Amount) FROM fees where income_class = 'Renewal'))
/ (select sum(Renewal_Budget) from `individual budgets`) * 100, 2),' %') as 'Renewal_Placed_Ach %';
   
# Renewal_Invoice_Ach %
select 'renewal' as Income_Class,
concat(round((select sum(Amount) from invoice where income_class = 'Renewal')
/ (select SUM(Renewal_Budget) from `individual budgets`) * 100, 2),' %') as 'Renewal_Invoice_Ach %';


# 5. No of meeting By Account Exec
select Account_Executive, count(account_executive) as No_Of_Meetings from  meeting
group by account_executive order by No_of_meetings desc;


# ********** Open Opportunities ********** 
select Account_Executive, Branch, Stage, count(opportunity_name) as No_Of_Opportunities, sum(revenue_amount) as Total_Revenue FROM opportunity 
where stage in ('Propose Solution', 'Qualify Opportunity') group by Account_Executive, branch, stage order by no_of_opportunities desc;

# ********** Closed Won Opportunities ********** 
select Account_Executive, branch, count(opportunity_name) as Closed_Won, sum(revenue_amount) as Closed_Won_Revenue from opportunity
where stage = 'negotiate'group by Account_Executive, branch;

# ********** Conversion Ratio ********** 
select Account_Executive,Branch,
sum(case when stage = 'negotiate' then 1 else 0 end) as Closed_Won, count(opportunity_name) as Total_Opportunities,
sum(case when stage = 'negotiate' then 1 else 0 end) / count(opportunity_name) as Conversion_Ratio from opportunity
group by Account_Executive, branch;

# KPI 6th : Top open opportunity
select Opportunity_Name, sum(revenue_amount) as Total_Sum from opportunity
where stage in ('Propose Solution','Qualify Opportunity') group by opportunity_name order by sum(revenue_amount) desc limit 10;



