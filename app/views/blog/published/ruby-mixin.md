---
title: 'Ruby mixin'
created_at: '2014-06-07'
author: 'ابوالفضل محمودی'
---
  
در زبان جاوا ما فقط class داریم (abstract و concrete). اما در زبان Ruby علاوه بر class، module و ترکیب (mixin) این دو نیز وجود دارد.
در Ruby به ترکیب شدن کلاس و ماجول mixin گفته می شود. به عبارت دیگر پیاده سازی کلاس و ماجول به هم پیوسته و درهم تنیده می شود. با یک ترکیب (mixin) شما می توانبد ساختار یک ماجول را به جای کلاس، گسترش (extend) دهید. قبل از اینکه شروع کنیم کمی درباره ماجول ها صحبت کنیم.
من فکر می کنم یک ماجول شبیه به یک کلاس انتزاعی (abstract) است. یک ماجول می تواند متدها، ثابت ها، کلاس ها و ماجول های دیگر را در خود جای دهد. برخلاف کلاس شما نمی توانید از یک ماجول یک شی (object) ایجاد کنید اما به جای آن می توانید قابلیت های (functionality) یک ماجول را به یک کلاس یا یک شی از کلاس اضافه کنید. در ماجول نمی توان از ویژگی ارث بری (inheritance) استفاده کرد.
 تفاوت بین ماجول و کلاس در این است که نام ماجول یک namespace ایجاد می کند که خود شبیه بودن نام متد ها را امکان پذیر می سازد:
    <!--more-->
    
```ruby

1.	# p058mytrig.rb  
2.	module Trig  
3.	  PI = 3.1416  
4.	  # class methods  
5.	  def Trig.sin(x)  
6.	    # ...  
7.	  end  
8.	  def Trig.cos(x)  
9.	    # ...  
10.	  end  
11.	end  
12.	  
13.	# p059mymoral.rb  
14.	module Moral  
15.	  VERY_BAD = 0  
16.	  BAD         = 1  
17.	  def Moral.sin(badness)  
18.	    # ...  
19.	  end  
20.	end  
21.	  
22.	# p060usemodule.rb  
23.	require_relative 'p058mytrig'  
24.	require_relative 'p059mymoral'  
25.	Trig.sin(Trig::PI/4)  
26.	Moral.sin(Moral::VERY_BAD)

```
دوم امکان به اشتراک گذاشتن قابلیتهای یک ماجول بین کلاس های مختلف. اگر یک کلاس با یک ماجول ترکیب شود متدهای نمونه (instance) آن ماجول در کلاس قابل دسترس است (mixin):
```ruby

1.	# p061mixins.rb  
2.	module D  
3.	  def initialize(name)  
4.	    @name =name  
5.	  end  
6.	  def to_s  
7.	    @name  
8.	  end  
9.	end  
10.	  
11.	module Debug  
12.	  include D  
13.	  # Methods that act as queries are often  
14.	  # named with a trailing ?  
15.	  def who_am_i?  
16.	    "#{self.class.name} (\##{self.object_id}): #{self.to_s}"  
17.	  end  
18.	end  
19.	  
20.	class Phonograph  
21.	  # the include statement simply makes a reference to a named module  
22.	  # If that module is in a separate file, use require to drag the file in  
23.	  # before using include  
24.	  include Debug  
25.	  # ...  
26.	end  
27.	  
28.	class EightTrack  
29.	  include Debug  
30.	  # ...  
31.	end  
32.	  
33.	ph = Phonograph.new("West End Blues")  
34.	et = EightTrack.new("Real Pillow")  
35.	puts ph.who_am_i?  
36.	puts et.who_am_i?

```

مثال های دیگر1:
```ruby

1.	#  p062stuff.rb  
2.	#  A module may contain constants, methods and classes.  
3.	#  No instances  
4.	  
5.	module Stuff  
6.	  C = 10  
7.	  def Stuff.m(x)  # prefix with the module name for a class method  
8.	    C*x  
9.	  end  
10.	  def p(x)        # an instance method, mixin for other classes  
11.	    C + x  
12.	  end  
13.	  class T  
14.	    @t = 2  
15.	  end  
16.	end  
17.	puts Stuff::C     # Stuff namespace  
18.	puts Stuff.m(3)   # like a class method  
19.	x = Stuff::T.new  
20.	# uninitialized constant error, if you try the following  
21.	# puts C  
22.	  
23.	#------------  
24.	  
25.	# p063stuffusage.rb  
26.	require_relative 'p062stuff'     # loads Stuff module from Stuff.rb  
27.	                    # $: is a system variable -- contains the path for loads  
28.	class D  
29.	  include Stuff     # refers to the loaded module  
30.	  puts Stuff.m(4)  
31.	end  
32.	  
33.	d = D.new  
34.	puts d.p(5)         # method p from Stuff  
35.	puts $:             # array of folders to search for load  
36.	$: << "c:/"         # add a folder to the load path  
37.	puts $:  
38.	puts Stuff.m(5)     # Stuff class methods not called from D object

```
  
به خاطر داشته با شید که یک کلاس فقط میتواند توسط یک کلاس دیگر به ارث رود. اما امکان ترکیب چند ماجول با یک کلاس وجود دارد. نام کلاس بیشتر اسم هستند اما نام ماجول ها اغلب صفت هستند.  