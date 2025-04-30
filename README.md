収入（Income）
| Column             | Type       | Options     | Constraints          |
| ------------------ | ---------- | ----------- | -------------------- |
| date               | date       | null: false |                      |
| amount             | integer    | null: false | check: 'amount >= 0' |
| category_income_id | integer    | null: false | foreign_key: true    |
| labor_time         | integer    |             |                      |
| memo               | text       |             |                      |
| user               | references | null: false | foreign_key: true    |

date: 収入の発生日
amount: 収入金額（0以上）
category_income_id: 収入のカテゴリ（外部キー）
labor_time: 労働時間（時間単位）（任意）
memo: メモ（任意）
user_id: ユーザー情報（外部キー）

### Association
- belongs_to :user



支出（Expense）
| Column              | Type       | Options     | Constraints          |
| ------------------- | ---------- | ----------- | -------------------- |
| date                | date       | null: false |                      |
| amount              | integer    | null: false | check: 'amount >= 0' |
| category_expense_id | integer    | null: false | foreign_key: true    |
| memo                | text       |             |                      |
| image               | string     |             |                      |
| user                | references | null: false | foreign_key: true    |
| tag_list            | string     |             |                      |  <!-- タグのためのカラム -->

date: 支出の発生日
amount: 支出金額（0以上）
category_expense_id: 支出のカテゴリ（外部キー）
memo: メモ（任意）
image: 支出に関連する画像（任意）
user_id: ユーザー情報（外部キー）
tag_list: 支出に関連するタグ（複数のタグをカンマ区切りで追加できます）

### Association
- belongs_to :user
- acts_as_taggable_on :images  <!-- タグ機能追加 -->


ユーザー（User）
| Column             | Type   | Options     | Constraints  |
| ------------------ | ------ | ----------- | ------------ |
| nickname           | string | null: false |              |
| email              | string | null: false | unique: true |
| encrypted_password | string | null: false |              |

nickname: ユーザー名
email: ユーザーのメールアドレス（ユニーク）
password: パスワード（Deviseで管理）

### Association
- has_many :incomes
- has_many :expenses

