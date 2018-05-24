#develconfig

tmux,screen / zsh / vim / git 환경 설정 프로젝트.

필요한 자원

- zsh
- tmux or screen
- vim 7.x
- git

#설치하기

    mkdir <your ID>
    cd <your ID>
    git clone https://github.com/newro/develconfig.git
    develconfig/install.sh


#디렉토리 구조


|    이름    |            내용                                                 |
| ---------- | --------------------------------------------------------------- |
| /plugins   | 커스텀 플러그인 <br/> vimrc에서 'source' 명령으로 이 디렉토리의 파일들을 incldue한다.  |
| /snippets  | SnipMate 플러그용 snippets (자동 설치 미지원)                   |
| /syntax    | xCAT Log용 syntax                                               |
| colorawk   | tail용 color syntax                                             |
| README.md  | 지금 읽고 있는 파일                                             |
| install.sh | 설치파일 <br/>  각 모듈 환경설정 파일을 생성한다.               |
| tmux.conf  | ~/.tmux.conf -> ~/develconfig/tmux.conf                         |
| screenrc   | ~/.screenrc -> ~/develconfig/screenrc                           |
| zshrc      | ~/.zshrc	   -> ~/develconfig/zshrc                              |
| etc_zshrc  | /etc/zshrc  -> ~/develconfig/etc_zshrc                          |
| vimrc      | ~/.vimrc    -> ~/develconfig/vimrc                              |
| gitconfig  | ~/.gitconfig -> ~/develconfig/gitconfig                         |
| gitconfig_global | ~/.gitconfig_global -> ~/develconfig/gitconfig_global     |
| myrc       | ~/rundevel  -> ~/develconfig/myrc_local                         |
|            | myrc를 myrc_local로 복사한다                                    |



# Custom Vim 단축키 설명

|    이름    |            내용                                                 |
| ---------- | --------------------------------------------------------------- |
| F2         | Bundle Search (Vim plugin을 추가로 찾아보고 설치할 수 있다)     |
| F5         | paste mode Toggle (입력모드에서도 작동)                         |
| F6         | Buffer list (Tab list), 닫기(q)                                 |
| F9         | Folder Navigator Toggle                                         |
| F10        | Number line Toggle (입력모드에서도 작동)                        |
| F11        | Source Navigator Toggle                                         |
| F12        | Tlist Toggle                                                    |
| Alt + hjkl | Split 창간 상하좌우 이동                                        |
| + - / * (keypad)| 현재 창의 크기 조절                                        |
| ,z         | 좌측 탭 이동                                                    |
| ,x         | 우측 탭 이동                                                    |
| ,w         | 탭 닫기                                                         |
| Alt + n    | 새 탭 열기                                                      |
| ,h         | Hex Mode View Toggle                                            |


# Custom tmux 단축키 설명 (PREFIX : Ctrl + Q)

|    이름    |            내용                                                 |
| ---------- | --------------------------------------------------------------- |
| PREFIX y   | Copy Mode (마우스 스크롤 업으로 Copy Mode 동작)                 |
|     v      | Selection Mode (Shift + 마우스 드래그인 경우 Clipboard로 복사)  |
| PREFIX p   | Paste                                                           |
| PREFIX h   | Horizon-Split Pane                                              |
| PREFIX v   | Horizon-Split Pane                                              |
| CTRL hjkl  | Pane Move (Vi Style)                                            |
| PREFIX z   | Zoom Pane Toggle                                                |
| PREFIX x   | Pane Close                                                      |
| PREFIX m   | Mouse mode ON                                                   |
| PREFIX M   | Mouse mode OFF                                                  |
| Mouse Click| Pane/Window 선택 및 Pane Size 조정 가능                         |
| etc        | Screen 단축키와 거의 동일                                       |

