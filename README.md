RealityCheck - XTLS-Reality Masking Test
---

+ Dependencies: openssl gtk2
+ Compilation: Lazarus-3.8 (x86_64)

![](https://github.com/AKotov-dev/RealityCheck/blob/main/ScreenShot1.png)

**RU**
Программа позволяет узнать, работает ли маскировка `XTLS-Reality` на вашем прокси-сервере при подключении через него. В приложении используется инструкция:
```
openssl s_client -showcerts -connect <proxy_server>:443 -servername <masked_domain>
```
<proxy_server> — это IP-адрес или домен вашего прокси-сервера.
<masked_domain> — это домен, под который прокси маскируется (например, yahoo.com).
Посмотрите в выводе команды блок `subject` и `issuer`, который покажет, какой сертификат был выдан сервером. Вы должны увидеть сертификат для сайта yahoo.com или того, под который настроен прокси.

Если сертификат соответствует ожидаемому сайту, это подтвердит, что прокси правильно маскирует трафик. Программа не требует установки: скачайте и распакуйте архив [RealityCheck.tar.gz](https://github.com/AKotov-dev/RealityCheck/raw/refs/heads/main/RealityCheck.tar.gz); запустите файл `RealityCheck`, введите данные и нажмите кнопку `Check`.

**EN**
The program allows you to find out whether `XTLS-Reality` masking works on your proxy server when connecting through it. The application uses the instruction:
```
openssl s_client -showcerts -connect <proxy_server>:443 -servername <masked_domain>
```
<proxy_server> is the IP address or domain of your proxy server.
<masked_domain> is the domain under which the proxy is masked (for example, yahoo.com).
Look at the `subject` and `issuer` blocks in the command output, which will show which certificate was issued by the server. You should see a certificate for the yahoo.com site or the one the proxy is configured for.

If the certificate matches the expected site, this confirms that the proxy is masking traffic correctly. The program does not require installation: download and unzip the [RealityCheck.tar.gz](https://github.com/AKotov-dev/RealityCheck/raw/refs/heads/main/RealityCheck.tar.gz) archive; run the `RealityCheck` file, enter the data and click the `Check` button.

