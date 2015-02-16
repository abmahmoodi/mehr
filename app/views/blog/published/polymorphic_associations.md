---
title: ارتباط از نوع چند ریختی در Rails
created_at: '2015-02-16'
author: 'ابوالفضل محمودی'
---

ارتباط چند ریختی در rails به این معنی است که با یک کلید یک مدل به بیش از یک مدل دیگر تعلق داشته باشد. به صورت عادی همانطور که می‌دانید یک مدل از طریق یک کلید خارجی فقط می‌تواند به یک مدل دیگر تعلق داشته باشد.

<!--more-->

چه نیازی به این نوع ارتباط داریم؟
در Rails یک ActiveRecord با یک روش از پیش تعریف شده بین جدول های مختلف در پایگاه داده ارتباط ایجاد میکند. برای مثال برای ایجاد یک ارتباط باید یک فیلد که نام آن به این شکل است (model_name_id) در جدول فرزند ایجاد میکنیم.
فرض کنید مدلی با نام User داریم که این مدل میتواند مالک مدل دیگری با نام Profile باشد:

```ruby

# /app/models/user.rb
class User < ActiveRecord::Base
  has_one :profile, dependent: :destroy
end
 
# /app/models/profile.rb
class Profile < ActiveRecord::Base
  belongs_to :user
end

```

زمان ایجاد جدولprofiles نیاز به فیلدی داریم که به مالک خود اشاره میکند. با توجه به اینکه مالک profile میتواند user باشد. یک فیلد با نام user_id در جدول profiles این ارتباط را ایجاد خواهد کرد.

```
rails generate model Profile user_id:integer:index name:string:index
rake db:migrate
```
اگر فرض کنیم که ما یک user با شناسه ۱ داریم برای ایجاد profile مرتبط با آن باید کد زیر را اجرا کنیم:

```ruby

Profile.new(
  user_id: 1,
  name: "Master of Lorem Ipsum"
).save

```

حالا اگر ما has_one و belongs_to در مدل های User و Profile داشته باشیم خیلی ساده میتوانیم به اطلاعات profile آنuser دسترسی داشته باشیم:

```ruby

user = User.first
user.profile.name

```

و اگر بخواهیم یک user را از طریق profileش پیدا کنیم:

```ruby

profile = Profile.where(name: "Master of Lorem Ipsum").first
profile.user.id

```


حال اگر این مدل Profile به بیش از یک مدل تعلق داشته باشد چه؟ مثلاً مدل دیگری داریم به نام Business که این هم شامل یک Profile است.به طور ساده می‌توان فیلد دیگری در جدول profiles ایجاد نمود با نام business_id ه این ارتباط را ایجاد کند. اما اگر تعداد این مدل ها زیاد شود این روش کار مناسبی نیست. در اینجا polymorphic به کمک ما می آید.
چطور این کار انجام میشود؟
در روش چند ریختی در جدول profiles  ما 2 فیلد داریم: یک فیلد نوع مالکیت و فیلد دوم شناسه مالک را مشخص میکنند. و در Rails به این صورت ایجاد میشود:

```

rails g model Profile name:string:index profileable:references{polymorphic}
rake db:migrate

```

با اجرای این دستورت ما ۲ فیلد در مدل Profile خواهیم داشت: profileable_id و profileable_type و مدل های ما به این شکل خواهند بود:

```ruby

# /app/models/user.rb
class User < ActiveRecord::Base
  has_one :profile, as: :profileable, dependent: :destroy
end
 
# /app/models/business.rb
class Business < ActiveRecord::Base
  has_one :profile, as: :profileable, dependent: :destroy
end
 
# /app/models/profile.rb
class Profile < ActiveRecord::Base
  belongs_to :profileable, polymorphic: true
end

```

رکوردهای Profile به شکل زیر ایجاد می شود:

```ruby

user = User.first
Profile.new(
  profileable_id: user.id,
  profileable_type: user.class.name,
  name: "Master of Lorem Ipsum"
).save
 
business = Business.first
Profile.new(
  profileable_id: business.id,
  profileable_type: business.class.name,
  name: "Taco Shell"
).save

```

