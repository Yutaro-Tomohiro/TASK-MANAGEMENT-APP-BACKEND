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

### Guard について
* このレポジトリには `guard` を導入しています。  
* `guard` は、ファイルの変更を監視し、指定されたタスク（テストの実行、Lint の適用、アプリの再起動など）を自動的に実行する Ruby 用のツールです。  
* `rspec` と `rubocop` を監視対象に加えているため、`guard` を実行している間はファイルの変更があると **自動でテストと Lint チェック** を実行します。  
* 以下のコマンドで `guard` を起動できます。  

```sh
docker compose exec bundle exec guard
```

## API 仕様
以下のファイルを参照してください。

* `schema/schema.yml`

## システム構成や設計上の選択理由など、実装内容の概要

### システム構成
* **Ruby, Ruby on Rails**
  * 最も慣れているサーバーサイドの言語であり、短期間での開発には特に力を発揮しやすいため選択しました。
  
* **PostgreSQL**
  * MySQL とどちらを選ぶべきか悩みましたが、[Stack Overflowの2024年版開発者調査](https://survey.stackoverflow.co/2024/technology#1-databases)で PostgreSQL の普及率が高いことを知り、興味を持って採用しました。

* **Docker**
  * コードを見ていただく際の実行環境を考慮した際、コンテナベースの方が環境構築が簡単であると考えました。
  * Podman も選択肢に挙がりましたが、 Docker を使い慣れており、短期間の開発にはこちらが適していると考えました。

### 実装でこだわった点

#### エラーハンドリング
* エラー処理は `ApplicationController` に集約し、各コントローラーでのエラーハンドリングの共通化を図りました。
* エラー発生時は、エラークラスのインスタンスを生成するだけで済む設計にすることで、エラーハンドリングをシンプルにしました。
* ただし、エラーステータスごとにメッセージを固定化したため、エラー調査時に柔軟な情報提供が難しくなるケースがありました。この点については、エラーメッセージを動的に渡せるように改善の余地があると感じています。

#### Formオブジェクト、Serviceオブジェクト、Repositoryオブジェクトの使用
* **Formオブジェクト**: バリデーションを担当し、リクエストを安全に行えるように設計しました。
* **Serviceオブジェクト**: 主にビジネスロジックの「what」をまとめ、処理内容が直感的に理解できるようにしました。
* **Repositoryオブジェクト**: 「how」に関する処理を隠蔽し、責務を明確に分離しました。
* また、Service と Repository の各クラスにはインターフェースを定義し、YARDコメントでインプットとアウトプットを記載することで、他の開発者がコードを理解しやすいように工夫しました。

#### DB構造
* ユーザー情報と認証情報は、それぞれ異なるユースケースで利用されると考えたため、テーブルを分割しました。
* この設計により、ユースケースごとに最小限の情報を取り扱うことができ、パフォーマンス面で有利な影響を与えることができたと考えています。

#### 認証ロジック
* 本アプリケーションは、フロントエンドとバックエンドが同一ドメインで動作する前提で設計しました。
* 理由は、Cookie の SameSite: Strict を利用することで、CSRF攻撃の対策が簡単に行えるためです。
* さらに、httpOnly:true にすることで、XSS攻撃にも対応できるため、セキュリティ面で優れた対応が可能です。
  * [参考サイト](https://qiita.com/Hiro-mi/items/18e00060a0f8654f49d6#session%E3%82%92%E7%94%A8%E3%81%84session%E3%82%92%E8%A8%80%E3%81%86%E3%81%8B%E5%89%8D)
* JWTの暗号鍵は、`credentials.yml` で暗号化して保存し、セキュリティを確保しました。
* `credentials.yml` は、Railsアプリケーション内で機密情報（APIキー、パスワードなど）を安全に管理するためのファイルです。
* `master.key` がないと複合できないため、安全に秘密情報をサーバーにアップロードできます。このキーは `.gitignore` に追加して、漏洩しないように管理しています。

#### GitHub Actions の CI を導入  
* GitHub へのプッシュ時に自動で Lint チェックとテストを実行するように設定しました。  
* これにより、コードの品質を継続的に保ち、問題を早期に発見できるようになったと思います。  
* Secrets を活用し、認証が関わるテストも CI 環境で実行可能にする工夫を施しました。
