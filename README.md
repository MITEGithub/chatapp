数据库前端代码：
lib文件是单纯的源代码，还有一大堆用于多平台构建的文件，所以这个代码是无法编译的
代码结构如下：
.
├── components　（用于保存所有的自定义的组件）
│   ├── chat_bubble.dart
│   ├── invite.dart
│   ├── message_bubble.dart
│   ├── my_button.dart
│   ├── my_drawer.dart
│   ├── my_textfield.dart
│   ├── rec_message.dart
│   ├── room_list.dart
│   ├── showDialog.dart
│   └── user_tile.dart
├── firebase_options.dart　
├── main.dart　（主函数）
├── model　（用来定义所有的数据结构［相当于ER图中的对象］）
│   ├── firend.dart
│   ├── group.dart
│   ├── message.dart
│   ├── room.dart
│   └── user.dart
├── pages　（项目中所有的页面设计）
│   ├── add_room.dart
│   ├── chat_pages.dart
│   ├── detail.dart
│   ├── email_content.dart
│   ├── home_pages.dart
│   ├── invite_page.dart
│   ├── login_page.dart
│   ├── recieve.dart
│   ├── register_pages.dart
│   ├── search.dart
│   ├── search_result_page.dart
│   ├── setting_pages.dart
│   └── user_info.dart
├── services　（项目中所有的服务）
│   ├── auth　（登入鉴权服务）
│   │   ├── login_or_register.dart
│   │   └── private_or_group.dart
│   ├── normal　（常规单实例化）
│   │   ├── auth_service.dart
│   │   ├── msg.dart
│   │   └── myuser_service.dart
│   └── web　（网络服务）
│       ├── http_service.dart　（HTTP方式）
│       └── websocket_service.dart　（WebSocket方式）
└── themes　（主题设置）
    ├── dart_mode.dart
    ├── light_mode.dart
    └── themes_provider.dart
