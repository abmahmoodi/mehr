---
title: 'SRP در Ruby'
created_at: '2014-07-19'
author: 'ابوالفضل محمودی'
---
اصل اول در طراحی شی گرا (۱) میگوید که یک کلاس فقط و فقط یک دلیل برای تغییر داشته باشد.
به عبارت دیگر متدهای یک کلاس فقط برای یک دلیل باید تغییر کنند، آن‌ها نباید به دلایل اجباری مختلف تغییر کنند.
<!--more-->

برای مثال فرض کنید در جاوا یک کلاس شبیه این وجود دارد:

```java
class Employee
{
  public Money calculatePay() {...}
  public void save() {...}
  public String reportHours() {...}
}

```

این کلاس اصل SRP را نقض می‌کند زیرا ۳ دلیل برای تغییر در آن وجود دارد. اول، قوانین کسب و کار (2) هستند که مربوط به محاسبات پرداخت میشود. دوم، ارتباط با پایگاه داده برای ذخیره داه ها. سوم، شکل دهی به رشته ای که ساعت را گزارش می‌کند. ما یک کلاس واحد را برای اجرای ۳ وظیفه مختلف نمی‌خواهیم. ما نمی‌خواهیم این کلاس هر زمان کاربران تصمیم به تغییر شکل ساعت گرفتند و یا مدیر پایگاه داده تصمیم به تغییر مدل پایگاه داده گرفت و یا مدیر امور مالی محاسبات لیست حقوق را تغییر داد، تغییر کند. بلکه ما می‌خواهیم این ۳ متد را در ۳ کلاس مختلف قرار داده و تغییرات در آن‌ها مستقل از یکدیگر انجام شود.
خوب حالا وضعیت در Ruby کمی متفاوت است. به فایل‌های منبع زیر توجه کنید:


```ruby

employeeBusinessRules.rb
class Employee
  def calculatePay ... end
end

employeeDatabaseSave.rb
class Employee
  def save ... end
end

employeeHourlyReport.rb
class Employee
  def reportHours ... end
end

```
در Ruby تا زمانیکه کلاس ها در زمان اجرا ساخته می‌شوند در هر زمانی از اجرای برنامه ممکن است متدها و متغیرهای مختلفی به آن اضافه شود. در برنامه اصلی ممکن است چیزی شبیه به این ببینید:


```ruby

require 'employeeBusinessRules.rb'
require 'employeeDatabaseSave.rb'
require 'employeeHourlyReport.rb'

```

بنابراین کلاس قبل از اجرای برنامه کامل خواهد شد. و هنوز هیچ فایل منبع واحدی شامل ۳ متد مختلف نمی‌باشد. بنابراین ۳ فایل منبع، چیزی در مورد همدیگر نمی‌دانند.
در Ruby روشی وجود دارد بطوریکه متد در یک کلاس قرار گرفته و متعلق به آن کلاس باشد بدون اینکه به اصل SRP لطمه ای وارد شود. بطور ساده برای اینکه به هدف مورد نظرمان برسیم،   متدهایی که به دلایل مختلف باید تغییر کنند را در فایل‌های منبع مختلف قرار می‌دهیم.

```ruby

#in employee_database.rb
module EmployeeDatabaseInstanceMethods
  def save ... end
end
#in employee_reports.rb
module EmployeeReportsInstanceMethods
  def report_hours ... end
end
#in employee.rb
class Employee
  include EmployeeDatabaseInstanceMethods
  include EmployeeReportsInstanceMethods
  def calculate_pay ... end
end

```


در مثالی دیگر موضوع را بیشتر توضیح می دهم. فرض کنید کلاسی داریم که کار آن اعتبار سنجی نام کاربری و گذرواژه است.


```ruby
class AuthenticatesUser
  def authenticate(email, password)
    if matches?(email, password)
     do_some_authentication
    else
      raise NotAllowedError
    end
  end

  private
  def matches?(email, password)
    user = find_from_db(:user, email)
    user.encrypted_password == encrypt(password)
  end
end
```

 در این کلاس متدی وجود دارد (authenticate) که کار آن چک کردن اعتبار نام کاربری و گذرواژه است. در اینجا متد دیگری (matches) فراخوانی می‌شود که کار خواندن نام کاربری و گذرواژه از پایگاه داده و مقایسه آن‌ها با ورودی متد میباشد. اگر دقت کنیم متوجه خواهیم شد که در این کلاس ۲ کار مختلف انجام می‌شود که مغایر با اصل SRP است. حالا با تمیز کاری کد میخواهیم این مشکل را حل کنیم:

```ruby
class AuthenticatesUser
  def authenticate(email, password)
    if MatchesPasswords.new(email, password).matches?
     do_some_authentication
    else
      raise NotAllowedError
    end
  end
end

class MatchesPasswords
  def initialize(email, password)
     @email = email
     @password = password
  end

  def matches?
     user = find_from_db(:user, @email)
    user.encrypted_password == encrypt(@password)
  end
end
```

به این روش Extract Class گفته می‌شود که در آن توسط [Composition](http://en.wikipedia.org/wiki/Composition_over_inheritance "Composition")  رفتار یک کلاس در کلاس دیگر به اشتراک گذاشته میشود.



> 1. Object Oriented Design
> 2. Business Rules

