# テーブル設計

## users テーブル

| Column             | Type    | Options                   |
| ------------------ | ------- | ------------------------- |
| nickname           | string  | null: false               |
| email              | string  | null: false, unique: true |
| encrypted_password | string  | null: false               |


### Association

- has_many :recipes
- has_many :lists

## recipes テーブル

| Column           | Type       | Options                        |
| ---------------- | ---------- | ------------------------------ |
| title            | string     | null: false                    |
| url              | text       |                                |
| user             | references | null: false, foreign_key: true |


### Association

- belongs_to :user
- has_one :ingredient
- has_many :lists


## lists テーブル

| Column       | Type       | Options                        |
| ------------ | ---------- | ------------------------------ |
| date         | date       | null: false                    |
| user         | references | null: false, foreign_key: true |
| recipe       | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :recipe


## ingredients テーブル

| Column         | Type       | Options                        |
| -------------- | ---------- | ------------------------------ |
| ingredient     | string     |                                |
| amount         | integer    |                                |
| unit_id        | integer    |                                |
| recipe         | references | null: false, foreign_key: true |


### Association

- belongs_to :recipe