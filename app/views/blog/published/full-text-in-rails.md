---
title: جستجو از نوع full-text
created_at: '2014-08-14'
author: 'ابوالفضل محمودی'
---

در اینجا می خواهم در مورد تکنیک Full Text Search در ابزار برنامه نویسی Rails مطلبی بنویسم. این مطلب ترجمه ای است از مقاله ای با نام Full Text Search in Rails with ElasticSearch که در سایت http://sitepoint.com منتشر شده است.

<!--more-->

موتور جستجو از نوع full-text برای اینکه بتواند نزدیکترین نتیجه را پیدا کند، تمام کلمات موجود در یک سند را جستجو می کند ([wikipedia](http://en.wikipedia.org/wiki/Full_text_search/)).
برای مثال اگر شما بخواهید مقاله هایی در مورد Rails را جستجو کنید از واژه rails برای جستجو استفاده خواهید کرد و اگر از تکنیک فهرست کردن (indexing) استفاده نکرده باشید باید تمام رکوردهای موجود مورد پیمایش قرار گیرد که اصلا روش مناسبی برای این کار نیست. روش درست برای این کار استفاده از فهرست وارونه (inverted index) بوده که  تمام واژه های موجود در جدول را به محل آن ها در پایگاه داده آدرس دهی می کند.
برای مثال اگر یک کلید اصلی به شکل زیر فهرست شود:

```
article#1 -> "breakthrough drug for schizophrenia"
article#2 -> "new schizophrenia drug"
article#3 -> "new approach for treatment of schizophrenia"
article#4 -> "new hopes for schizophrenia patients"
...
```
یک فهرست وارونه به این شکل خواهد بود:

```
breakthrough  -> article#1
drug          -> article#1, article#2
schizophrenia -> article#1, article#2, article#3, article#4
approach      -> article#3
new           -> article#2, article#3, article#4
hopes         -> article#4
...
```
حالا جستجوی واژه “drug” با استفاده فهرست وارونه نتایج article#1, article#2 را خواهد داشت. برای اطلاعات بیشتر می توانید به [این](http://www-nlp.stanford.edu/IR-book) کتاب مراجعه کنید.

### ساخت یک وبلاگ ساده
در اینجا[مثال مشهوری](http://guides.rubyonrails.org/getting_started.html/) که در راهنمای Rails وجود دارد را با هم پیش می رویم.
دستورات زیر را در ترمینال اجرا کنید:
‍‍‍

```
‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍‍$ rails new blog
$ cd blog
$ bundle install
$ rails s‍‍‍
```
### ساخت Article Controller
این Controller با استفاده از تولید کننده Rails ایجاد شده و مسیرها به config/routes.rb اضافه می شود و متدهایی برای اضافه، نمایش و لیست مطالب ایجاد خواهد شد.
‍‍‍‍

```
$ rails g controller articles
```

پرونده config/routes.rb را باز کرده و دستور زیر را به آن اضافه کنید:

```ruby
Blog::Application.routes.draw do
  resources :articles
end
```

حالا پرونده app/controller/articles_coroller.rb را باز کرده و متدهایی برای اضافه، نمایش و لیست به آن اضافه نمایید:


```ruby
def index
  @articles = Article.all
end

def show
  @article = Article.find params[:id]
end

def new
end

def create
  @article = Article.new article_params
  if @article.save
    redirect_to @article
  else
    render 'new'
  end
end

private
  def article_params
    params.require(:article).permit :title, :text
  end
```

### Active Model
ما به یک model برای articles نیاز داریم بنابراین با دستورات زیر آن را ایجاد می کنیم:

```
$ rails g model Article title:string text:text
$ rake db:migrate
```

### فرمی برای ایجاد مطلب جدید
پرونده با نام app/views/articles/new.html.erb با محتوای زیر ایجاد می کنیم:

```
<h1>New Article</h1>  
 
<%= form_for :article, url: articles_path do |f| %>
 
  <% if not @article.nil? and @article.errors.any? %>
  <div id="error_explanation">
    <h2><%= pluralize(@article.errors.count, "error") %> prohibited
      this article from being saved:</h2>
    <ul>
    <% @article.errors.full_messages.each do |msg| %>
      <li><%= msg %></li>
    <% end %>
    </ul>
  </div>
  <% end %>
 
  <p>
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </p>
 
  <p>
    <%= f.label :text %><br>
    <%= f.text_area :text %>
  </p>
 
  <p>
    <%= f.submit %>
  </p>
<% end %>
 
<%= link_to '<- Back', articles_path %>
```

### نمایش یک مطلب
پرونده دیگری با نام app/views/articles/show.html.erb ایجاد می کنیم:


```
<p>
  <strong>Title:</strong>
  <%= @article.title %>
</p>
 
<p>
  <strong>Text:</strong>
  <%= @article.text %>
</p>
 
<%= link_to '<- Back', articles_path %>
```

### لیست همه مطالب
پرونده سوم را با نام app/views/articles/index.html.erb ایجاد می کنیم:

```
<h1>Articles</h1>
 
<ul>
  <% @articles.each do |article| %>
    <li>
      <h3>
        <%= article.title %>
      </h3>
      <p>
        <%= article.text %>
      </p>
    </li>
  <% end -%>
</ul>
<%= link_to 'New Article', new_article_path %>
```

حال شما می توانید مطالب را اضافه کرده و آن ها را نمایش دهید. دستور rails s را در ترمینال اجرا کرده و آدرس http://localhost:3000/articles را در مرورگر وارد کنید. سپس روی “New Article” کلیک کرده و مطالبی را اضافه کنید در اینجا می خواهیم جستجوی full-text را اضافه و آزمایش کنیم.

### اضافه کردن ElasticSearch
در حال حاضر ما فقط می توانیم مطالب را با شناسه آن ها بیابیم اما با اضافه شده ElasticSearch جستجوی مطالب با استفاده از واژه ها در عنوان و خود مطلب امکان پذیر خواهد بود.

### نصب در Ubuntu
به [این](http://www.elasticsearch.org/download/) آدرس رفته و فایل deb را دانلود کرده و دستور زیر را اجرا کنید:

```
$ brew install elasticsearch
```

برای تست نصب آدرس http://localhost:9200 را در مرورگر خود وارد کنید:

```
{
  "status" : 200,
  "name" : "Anvil",
  "version" : {
    "number" : "1.2.1",
    "build_hash" : "6c95b759f9e7ef0f8e17f77d850da43ce8a4b364",
    "build_timestamp" : "2014-06-03T15:02:52Z",
    "build_snapshot" : false,
    "lucene_version" : "4.8"
  },
  "tagline" : "You Know, for Search"
}
```

### اضافه کردن یک جستجوی ساده
برای این کار یک controller با نام search به برنامه اضافه میکنیم ولی قبل از آن افزونه های مرتبط با ElasticSearch را به پروژه اضافه می کنیم:

```ruby
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
```

به خاطر داشته باشید دستور bundle install را در ترمینال اجرا کنید.
ایجاد SearchController با دستور زیر انجام می شود:

```
$ rails g controller search
```

متد زیر را در فایل app/controller/search_controller.rb را اضافه کنید:

```ruby
def search
  if params[:q].nil?
    @articles = []
  else
    @articles = Article.search params[:q]
  end
end
```

### اضافه کردن جستجو به Article
برای اضافه شدن جستجو به این Model باید از کتابخانه elasticsearch/model استفاده شود. پرونده app/models/article.rb را به شکل زیر تغییر دهید:

```ruby
require 'elasticsearch/model'

class Article < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
end
Article.import # for auto sync model with elastic search
```

یک پرونده جدید با نام app/views/search/search.html.erb ایجاد کنید:

```
<h1>Articles Search</h1>
 
<%= form_for search_path, method: :get do |f| %>
  <p>
    <%= f.label "Search for" %>
    <%= text_field_tag :q, params[:q] %>
    <%= submit_tag "Go", name: nil %>
  </p>
<% end %>
 
<ul>
  <% @articles.each do |article| %>
    <li>
      <h3>
        <%= link_to article.title, controller: "articles", action: "show", id: article._id%>
      </h3>
    </li>
  <% end %>
</ul>
```

مسیر جستجو را در پرونده config/routes.rb اضافه کنید:

```ruby
get 'search', to: 'search#search'
```

حالا می توانید به آدرس http://localhost:3000/search در مرورگر وارد شده و هر واژه ای را در مطالب جستجو کنید.
