---
title: 'OCP در Ruby'
created_at: '2014-07-23'
author: 'ابوالفضل محمودی'
---

در بخش گذشته در مورد اصل SRP در برنامه نویسی شی گرا توضیحاتی داده شد. در این بخش می خواهم در مورد اصل Open/closed در زبان برنامه نویسی Ruby توضیحاتی ارائه دهم.
اصل OCP می گوید هر یک از موجودیت های نرم افزار (شامل کلاس، ماجول، توابع و ...) مجاز به توسعه هستند اما نباید آن ها را تغییر داد. یعنی اینکه یک موجودیت می تواند رفتارش را بدون تغییر در کد منبع تغییر دهد. [OCP] (http://en.wikipedia.org/wiki/Open/closed_principle)
<!--more-->

به مثال زیر توجه کنید:

```ruby
class Report
  def body
     generate_reporty_stuff
  end

  def print
     body.to_json
  end
end
```

این کلاس اصل OCP را نقض می کند زیرا اگر بخواهیم فرمت چاپ را تغییر دهیم باید کد کلاس تغییر کند. برای حل این مشکل کد را به شکل زیر تغییر می هیم:

```ruby
class Report
  def body
     generate_reporty_stuff
  end

  def print(formatter: JSONFormatter.new)
     formatter.format body
  end
end
```

خوب حالا برای تغییر فرمت، به شکل زیر از این کلاس استفاده می کنیم:

```ruby
report = Report.new
report.print(formatter: XMLFormatter.new)
```

همانطور که می بینید قابلیت کلاس بدون تغییر در کد منبع قابل تغییر است. در این مثال از تکنیکی با عنوان [Dependency Injection](http://en.wikipedia.org/wiki/Dependency_injection) استفاده شده است.

