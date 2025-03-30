# README

## 起動⼿順および依存関係のインストール⽅法

以下のコマンドを順番に実行してください。

* `docker compose build`
* `docker compose run web rails db:create`
* `docker compose run web rails db:migrate`
* `docker compose up`

## テスト実⾏⽅法
以下のコマンドを実行してください。

* `docker compose run web rspec`

## 使⽤している Linter/Formatter の説明と設定⽅法
* 説明
* 使用方法
  * `docker compose run web rubocop`

## API 仕様
以下のファイルを参照してください。

* `schema/schema.yml`

## システム構成や設計上の選択理由など、実装内容の概要
