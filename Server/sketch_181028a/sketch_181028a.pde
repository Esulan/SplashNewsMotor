
//ライブラリのインポート
import processing.net.*;
//サーバのインスタンス
Server server;
//カウンタ用変数
int val = 0;

void setup() {
  size(200, 200);
  //サーバの設定（ポート：12345）
  server = new Server(this, 12345);
}

void draw() {
  //クライアントからの受信確認
  Client client = server.available();

  //クライアントがいる場合
  if (client!=null) {
    //クライアントIPアドレス出力
    println("Client IP Address : " + client.ip());
    //クライアントからのデータがあるとき
    if(client.available() > 0){
      //データ読み込み（HTTPリクエスト読み込み）
      String clientData = client.readString();
      
      println(clientData + "\n");
      //データを改行コードをもとに区切り、
      //改行コードを取り除いてから配列に代入していく
      String[] httpRequest=trim(split(clientData,'\n'));
      
      println(httpRequest);
      //受信データの最初の内容が「GET / HTTP/1.1」の場合
      
      if(httpRequest[0].equals("GET / HTTP/1.1")){
          //以下の内容をクライアントへ返信する（HTTPレスポンス）
          
          println(httpRequest[0]);
          
          client.write("HTTP/1.1 200 OK\n");//接続成立
          client.write("Content-Type: text/html\n");//HTML文書形式
          client.write("\n");//空白行
        
          client.write("<h2>Hoge</h2>");
        }
      
      
      for(int i = 0; i < httpRequest.length; i++){
        if(httpRequest[i].equals("Refere")){
          //以下の内容をクライアントへ返信する（HTTPレスポンス）
          
          println(httpRequest[i]);
        }
      }
      client.stop();//クライアントとの接続を停止
    } 
  }
}