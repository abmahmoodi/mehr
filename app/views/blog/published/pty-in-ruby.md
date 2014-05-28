---
title: 'کتابخانه PTY در Ruby'
created_at: '2014-05-28'
author: 'ابوالفضل محمودی'
---
کتابخانه استاندارد PTY روش مناسبی برای اجرای دستورات در سیستم عامل هایی مثل یونیکس و لینوکس است. دستور Spawn در این کتابخانه برای شبیه سازی یک ترمینال و اجرای دستورات به صورت real-time کارا و مفید است.

زمانیکه می خواستم دستورات مخزن کد Git را در زبان برنامه نویسی Ruby اجرا کنم با کتابخانه PTY آشنا شدم و فهمیدم که با آن به هدفی که می خواهم می رسم. کاری که می خواستم انجام دهم دقیقا این بود که یکی از دستورات Git را در یکی از نرم افزارهایی که با  Ruby on Rails نوشته شده بود اجرا کنم. این دستور git clone است و کاربرد آن ایجاد یک کپی از یک کد منبع در سیستم کاربر است. زمانیکه بخواهیم این دستور را برای کپی کد منبعی که روی سرور راه دور قرار دارد اجرا کنیم، در صورتی که کلید عمومی روی سرور موجود نباشد از شما کلمه عبور می خواهد. در اصل این کلمه عبور برای احراز هویت کاربر از او درخواست می شود. شیوه اجرای آن به این شکل است:

`git clone user@server:my_repository.git`
بعد از اجرای این دستور در یک ترمینال، پیام زیر نمایش داده می شود:

`user@server's password:`
<!--more-->
و ترمینال منتظر می شود تا کلمه عبور وارد شود. بعد از وارد کردن کلمه عبور کد منبع روی سیستم کاربر در مسیر جاری کپی می شود. برای شبیه سازی این فرایند نیاز است که اجرای این دستور شبیه سازی شده و زمانیکه سیستم کلمه عبور را درخواست کرد نرم افزار آن را به صورت خودکار تشخیص داده و کلمه عبور را وارد کند. در کتابخانه PTY دستور spawn این کار را به راحتی انجام می دهد:

```ruby
def pty(cmd, &block)
  PTY.spawn(cmd, &block)
  $?.exitstatus
end

def run_clone_command(app_cmd, url, password = '')
  output = ''
  status = Cmd.pty("#{app_cmd} clone #{url}") do |reader, writer, pid|
  begin
    reader.expect(/password/)
    writer.puts(password)
    reader.expect(/\$|password/) do |a, b|
      if a.match(/\$/)
        reader.each_line { |line| output << line; }
      else
        raise 'Password is not valid.'
      end
    end
    rescue Errno::EIO
    end
    Process.wait(pid)
  end
  if status != 0
    raise "Command exited with non-zero status: #{status}"
  end
  #output
end
```

در تابع pty اول دستور spawn اجرا شده و سپس وضعیت جاری برگشت داده می شود. وضعیت جاری همان درست اجرا شدن و یا نشدن دستور git clone بوده و مقدار بازگشتی آن کد 0 و یا 128 می باشد.

تابع run_clone_command اول با استفاده پارامترهای ورودی تابع pty را اجرا می کند. خوب حالا برای اینکه از بازخوردهای آن سردر بیاوریم باید از پارامترهای بلاک (reader, writer, pid) استفاده کنیم. در اینجا تابع expect به کمک ما می آید. ما می خواهیم بدانیم که چه زمانی بعد از اجرای دستور از ما گذرواژه درخواست می شود. این تابع یک الگو به عنوان ورودی دریافت میکند و درصورتی که پیام های خروجی اجرای دستور، منطبق با الگو باشد مجموعه دستورات در بلاک خود را اجرا می کند. و یا اگر بلاکی در کار نباشد دستور بعد از خود را اجرا می کند. در اینجا برنامه منتظر است که اجرای دستور git clone گذرواژه را درخواست کند سپس برنامه با استفاده از تابع puts از پارامتر write مقدار گذرواژه را وارد می کند و در صورت درست بودن آن خروجی ها نمایش داده می شود.

مشکلی که تابع spawn دارد اینست که در لینوکس بعد از اجرای کامل آن، یک استثنا رخ می دهد که باید اداره شده و نادیده گرفته شود. در پایان برای اینکه بتوان خروجی status را خواند، باید از دستور Process.wait استفاده کرد که وظیفه آن انتظار تا اجرای کامل دستور می باشد.