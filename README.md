# Docker image for LaTeX
TeXLiveに様々な機能を追加したDocker imageです。

## Usage

[こちらのテンプレートリポジトリ](https://github.com/being24/latex-template-ja)と組み合わせて使用することを想定しています。
詳細は[こちら](https://zenn.dev/being/articles/how-to-use-my-latex)を参照してください。
ですが、それ以外の環境でも使用可能です。

コマンドラインからの場合、以下のように使用することができます。
カレントディレクトリにビルドしたいtexソースがあるとします．

```bash
docker run -u $(id -u):$(id -g) --rm -v $PWD:/workdir ghcr.io/being24/latex-docker latexmk main.tex
```

これでカレントディレクトリに `main.pdf` ができます．

## Version

| Image tag | Ubuntu | TeXLive      | Arch         | Registry            |
| --------- | ------ | -------      | -----------  | ------------------  |
| 3.0.3     | 20.04  | 2022         | amd64, arm64 | ghcr.io             |
| 3.1.0     | 20.04  | 2022         | amd64, arm64 | docker.io, ghcr.io  |
| 3.2.6     | 20.04  | 2022(frozen) | amd64, arm64 | docker.io, ghcr.io  |
| 3.2.8     | 20.04  | 2023         | amd64, arm64 | docker.io, ghcr.io  |

## Author

being24

## License

MIT

## Pull Image

```bash
docker pull ghcr.io/being24/latex-docker:latest
```

## About Libraries of Special Note

* minted
  * listing系は導入や設定が煩雑だったりということもあり、モダンなライブラリとして採用しました。python3に依存するためdocker imageにから削除していません。

* siunitx
  * 何も考えずに単位を数式として表示すると斜体になってしまうなど不都合があります。これを回避するために導入しました。

* latexindent
  * latexソースコード用のformatterです。ソースコードのインデントを自動で揃えるようにしました。perlに依存するためdocker imageにから削除していません。

## Embedding font

一部の論文誌等ではフォントの埋め込みを提出の要件にしています。
現在は基本的にTeXLiveの標準フォントが埋め込まれるため必要ありませんが、念のため残しておきます。

そういった場合以下のコマンドをコンテナ内で使用することでフォントの埋め込みが可能です。

```bash
gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dEmbedAllFonts=true -sOutputFile=output.pdf -f input.pdf
```

注意点として、matplotlib等でグラフをpdf形式で出力している場合は、そちらにも作成時にフォントを埋め込んでおく必要があります。
また、一部学会でグラフにtimes new romanを使用することを求めていますが、このフォントは上の方法を用いて埋め込むとフォントの規約違反となることに注意してください。Adobe Acrobat Pro DCを使用してフォントをロックする必要があります。

## PDF Version

論文等提出時に、PDFのバージョンが指定されている場合があります。
そういった場合、.latexmkrcの

```bash
$dvipdf = 'dvipdfmx %O -o %D %S';
```

を

```bash
$dvipdf = 'dvipdfmx -V 4 %O -o %D %S';
```

に変更することでバージョンを指定することができます。

## フォント
英語系のフォントはTeX Gyre Termesを、日本語系のフォントはHarano Ajiを使用しています。
