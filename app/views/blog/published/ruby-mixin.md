---
title: Ruby mixin'
created_at: '2014-06-06'
author: 'ابوالفضل محمودی'
---

در زبان جاوا ما فقط class داریم (abstract و concrete). اما در زبان Ruby علاوه بر class، module و ترکیب (mixin) این دو نیز وجود دارد.
در Ruby به ترکیب شدن کلاس و ماجول mixin گفته می شود. به عبارت دیگر پیاده سازی کلاس و ماجول به هم پیوسته و درهم تنیده می شود. با یک ترکیب (mixin) شما می توانبد ساختار یک ماجول را به جای کلاس، گسترش (extend) دهید. قبل از اینکه شروع کنیم کمی درباره ماجول ها صحبت کنیم.
من فکر می کنم یک ماجول شبیه به یک کلاس انتزاعی (abstract) است. یک ماجول می تواند متدها، ثابت ها، کلاس ها و ماجول های دیگر را در خود جای دهد. برخلاف کلاس شما نمی توانید از یک ماجول یک شی (object) ایجاد کنید اما به جای آن می توانید قابلیت های (functionality) یک ماجول را به یک کلاس یا یک شی از کلاس اضافه کنید. در ماجول نمی توان از ویژگی ارث بری (inheritance) استفاده کرد.
 تفاوت بین ماجول و کلاس در این است که نام ماجول یک namespace ایجاد می کند که خود شبیه بودن نام متد ها را امکان پذیر می سازد:

```ruby

# p058mytrig.rb  
module Trig  
  PI = 3.1416  
  # class methods  
  def Trig.sin(x)  
    # ...  
  end  
  def Trig.cos(x)  
    # ...  
  end  
end  
  
# p059mymoral.rb  
module Moral  
  VERY_BAD = 0  
  BAD         = 1  
  def Moral.sin(badness)  
    # ...  
  end  
end  
  
# p060usemodule.rb  
require_relative 'p058mytrig'  
require_relative 'p059mymoral'  
Trig.sin(Trig::PI/4)  
Moral.sin(Moral::VERY_BAD)  

```

دوم امکان به اشتراک گذاشتن قابلیتهای یک ماجول بین کلاس های مختلف. اگر یک کلاس با یک ماجول ترکیب شود متدهای نمونه (instance) آن ماجول در کلاس قابل دسترس است (mixin):

```ruby

# p061mixins.rb
module D  
  def initialize(name)  
    @name =name  
  end  
  def to_s  
    @name  
  end  
end  
  
module Debug  
  include D  
  # Methods that act as queries are often  
  # named with a trailing ?  
  def who_am_i?  
    "#{self.class.name} (\##{self.object_id}): #{self.to_s}"  
  end  
end  
  
class Phonograph  
  # the include statement simply makes a reference to a named module  
  # If that module is in a separate file, use require to drag the file in  
  # before using include  
  include Debug  
  # ...  
end  
  
class EightTrack  
  include Debug  
  # ...  
end  
  
ph = Phonograph.new("West End Blues")  
et = EightTrack.new("Real Pillow")  
puts ph.who_am_i? 
puts et.who_am_i?  

```

مثال های دیگر:

```ruby

#  p062stuff.rb  
#  A module may contain constants, methods and classes.  
#  No instances  
  
module Stuff  
  C = 10  
  def Stuff.m(x)  # prefix with the module name for a class method  
    C*x  
  end  
  def p(x)        # an instance method, mixin for other classes  
    C + x  
  end  
  class T  
    @t = 2  
  end  
end  
puts Stuff::C     # Stuff namespace  
puts Stuff.m(3)   # like a class method  
x = Stuff::T.new  
# uninitialized constant error, if you try the following  
# puts C  
  
#------------  
  
# p063stuffusage.rb  
require_relative 'p062stuff'     # loads Stuff module from Stuff.rb  
                    # $: is a system variable -- contains the path for loads  
class D  
  include Stuff     # refers to the loaded module  
  puts Stuff.m(4)  
end  
  
d = D.new  
puts d.p(5)         # method p from Stuff  
puts $:             # array of folders to search for load  
$: << "c:/"         # add a folder to the load path  
puts $:  
puts Stuff.m(5)     # Stuff class methods not called from D object  

```

به خاطر داشته با شید که یک کلاس فقط میتواند توسط یک کلاس دیگر به ارث رود. اما امکان ترکیب چند ماجول با یک کلاس وجود دارد. نام کلاس بیشتر اسم هستند اما نام ماجول ها اغلب صفت هستند