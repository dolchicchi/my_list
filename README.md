## My_list
[![Image from Gyazo](https://i.gyazo.com/4d8e9cfae452cacc99d473619138f76e.gif)](https://gyazo.com/4d8e9cfae452cacc99d473619138f76e)
[![Image from Gyazo](https://i.gyazo.com/7fc77021343c2eebc9a6c5a402849319.jpg)](https://gyazo.com/7fc77021343c2eebc9a6c5a402849319)
## アプリケーション概要
献立をどうしようか悩んでいる人の手助けをするWebアプリケーションです。
特定の日に献立の登録や登録済みレシピから気分に合わせて献立のランダム生成も行えます。
家族間でアカウント共有すれば献立の予定を共有することやリクエストするような使い方もできます。
献立登録時に食材を登録しておけば買い物リストの作成も可能です。
## URL
http://13.231.2.50/
## 利用方法
1. ユーザー登録orログイン  
(ゲストログインで登録済みのアカウントでログインできます)
1. レシピの登録(レシピのタイトルのみでも登録可能)
1. トップページから献立の追加やおまかせメニューから献立のランダム作成が可能になります。
1. 食材を登録しておけば買い物リストの確認も可能になります。
## 使用技術
* Ruby 2.6.5
* Ruby on Rails 6.0.4.7
* Docker 20.10.14 / Docker-compose 2.4.1
* AWS EC2
* CI/CD CircleCI
* Capistrano 3.17.0
* Rspec
* unicorn 5.4.1
* Mysql 5.6.51
* nginx 1.20.0
* Rubocop
## DB設計
![](app/assets/images/ER%E5%9B%B3.svg)
## 画面遷移図
![](app/assets/images/screen.svg)
## インフラ構成図
![](app/assets/images/cloud.svg)
## 洗い出した要件
[要件を定義したシート](https://docs.google.com/spreadsheets/d/1Xa4weDya6gjDapaA8AAZ059wmQDttAZkOyN81plyQFM/edit#gid=982722306)