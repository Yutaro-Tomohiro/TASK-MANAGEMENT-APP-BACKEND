# README

## 起動⼿順および依存関係のインストール⽅法

* 以下のコマンドを順番に実行してください
  * macOS 環境を想定しています
  * Windows 環境の場合、Dockerfile 9 行目の処理の `COPY entrypoint.sh /usr/bin/` で `/usr/bin/` がないため、エラーになると思います

```bash
docker compose build
docker compose run web rails db:create
docker compose run web rails db:migrate
```


## テスト実⾏⽅法
### 実行方法
以下のコマンドを実行すると spec ディレクトリ内のすべてのテストを実行します
```bush
docker compose run web bundle exec rspec
```

特定のファイルだけをテストしたい場合は以下を実行してください
```bush
docker compose run web bundle exec rspec spec/models/user_spec.rb
```

Specのテスト実行後、テストの結果がターミナルに表示され、テストが成功した場合は緑色、失敗した場合は赤色で表示されます

## 使⽤している Linter/Formatter の説明と設定⽅法

### 使用方法
コードをチェックするには、以下のコマンドを実行します
```bush
docker compose run web  bundle exec rubocop
```

コードを自動修正するには、以下のコマンドを実行します
```bush
docker compose run web  bundle exec rubocop -a
```

特定のファイルやディレクトリを指定してチェックする場合
```bush
docker compose run web  bundle exec rubocop path/to/file.rb
```

### 設定
* `.rubocop.yml` という設定ファイルからプロジェクトごとにコードスタイルをカスタマイズができます
* 今回は `rubocop-rails-omakase` という Rails 7.2 から標準に組み込まれているものをベースにカスタマイズしています

## API 仕様
以下のファイルを参照してください。

* `schema/schema.yml`

## システム構成や設計上の選択理由など、実装内容の概要

### システム構成
* Ruby, Ruby on Rails
  * 一番使い慣れているサーバーサイドの言語のため、短期での開発では力を発揮しやすいと考えていたため 
* PostgreSQL
  * MySQL とどちらにすべきか悩んだが、[スタックオーバーフローが実施した開発者調査（2024年版）](https://survey.stackoverflow.co/2024/technology#1-databases) で PostgreSQL の普及率の方が高いことを知り、使ってみたくなったため
* Docker
  * 実行していただくことを考えると、コンテナベースにした方が環境構築が簡単だと考えた
  * Podman も選択肢にあったが、使い慣れている Docker の方が短期の開発に向いていると判断した

 ### 実装でこだわったところ

 #### エラーハンドリング
 * それぞれのコントローラーの継承元である `ApplicationController` でエラーの出しわけ処理を行えるように集約した
 * そのため、エラーをライズしたい箇所では エラークラスのインスタンスを生成するだけで良くなったため、全体的に簡単にエラーハンドリングができるようになった
 * 一方でエラーステータスごとにエラーメッセージを固定してしまったため、エラーの調査が難しくなることがあったため、エラーメッセージを渡せるように修正が必要だと反省している

#### Form オブジェクト, Service オブジェクト, Repository オブジェクトの使用
* Form オブジェクトで値のバリデーションを行い、安全に リクエストを行えるように実装
* Service オブジェクトにロジックの what の部分をまとめて、何をしているかをわかりやすくなるように実装
* Repository オブジェクトには Service で書かれているロジックの how の部分を隠蔽して、責務の分離ができるように意識した
* また、Service と Repository にはインターフェースを準備し、 yard コメントでインプットとアウトプットを書くことで、他の人が見たときに理解しやすくなるように工夫した

#### DB 構造
* API 設計をしていて、ユーザー情報と認証情報はそれぞれ別のユースケースで使いそうと思ったため、テーブルを分離した
* それによって、ユースケースごとに最小限の情報で済むためパフォーマンス面でいい影響を及ぼせたと考えている

#### 認証ロジック
* 今回のアプリはフロントとバックエンドが同一ドメインであることを前提に書いた
* 理由は Cookie の SameSite: Strict を使用することで CSRF の対策が簡単になるため
* 他にも httpOnly:true で XSS にも対応できるため
  * [参考サイト](https://qiita.com/Hiro-mi/items/18e00060a0f8654f49d6#session%E3%82%92%E7%94%A8%E3%81%84session%E3%81%AEcookie%E3%81%AFsamesitecookie)
* JWT の暗号鍵は credentials.yml に暗号化して保存
* credentials.yml は Railsアプリケーションにおいて、秘密情報（APIキー、パスワード、その他のセキュアな設定など）を安全に管理する時に使われるファイル
* master.key がないと複合できないため、安全に秘密情報をサーバーにアップロードすることができる
  * master.key は漏洩しないように .gitignore に追加
