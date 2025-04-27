Checkbox Form Uygulaması
Erciyes Üniversitesi Bilgisayar Mühendisliği
Mobile Application Development Dersi - Vize Proje Ödevi

Proje Hakkında
Bu proje, Flutter kullanılarak geliştirilen bir mobil uygulamadır. Uygulama, kullanıcının programlama dilleri ve framework'ler hakkındaki tercihlerini checkbox'lar aracılığıyla seçmesine, bu tercihleri kaydetmesine ve daha sonra tekrar görüntülemesine olanak tanır.

Kullanılan Teknolojiler
Flutter: Kullanıcı arayüzünün geliştirilmesi için kullanılan cross-platform framework
Dart: Uygulama geliştirme dili
Material Design: Kullanıcı arayüz tasarım dili
SharedPreferences: Kullanıcı tercihlerini cihaz üzerinde kalıcı olarak saklamak için kullanılan yerel depolama API'si
Uygulama Özellikleri
Kullanıcı Tercihleri:

Java, Python, Flutter ve React teknolojileri için checkbox'lar
Seçilen teknolojilerin görsel olarak gösterilmesi
Veri Saklama:

SharedPreferences API'si kullanılarak kullanıcı tercihlerinin cihazda kalıcı olarak saklanması
Uygulama yeniden başlatıldığında kayıtlı tercihlerin otomatik olarak yüklenmesi
Modern UI:

Card, Container ve diğer Material Design bileşenlerinin kullanımı
Gölgeler, köşe yuvarlatmaları ve renk geçişleri ile zenginleştirilmiş arayüz
Responsive tasarım
Uygulama Mimarisi
Uygulama, modüler bir yapıda tasarlanmıştır:

main.dart: Ana uygulama girişi ve tema ayarlarını içerir
screens/checkbox_form_page.dart: Checkbox formunun oluşturulması ve veri depolama işlemlerini yönetir
Her bir UI bileşeni için ayrı metotlar oluşturularak kod okunabilirliği ve bakım kolaylığı sağlanmıştır.

Veri Saklama Mekanizması
Uygulama, SharedPreferences API'sini kullanarak veri saklar. Bu yaklaşım:

Basit anahtar-değer çiftleri olarak veri depolama
Uygulama kapansa bile verilerin kalıcı olması
Boolean, string, integer gibi basit veri tipleri için uygun olması
özellikleriyle öne çıkar. Veri saklama ve yükleme işlemleri asenkron metotlarla gerçekleştirilir.

Nasıl Çalışır?
Uygulama açıldığında, daha önce kaydedilmiş tercihler (varsa) yüklenir
Kullanıcı, checkbox'ları kullanarak tercihlerini belirler
"Tercihleri Kaydet" butonuna tıklandığında, tercihler cihaza kaydedilir
Seçilen teknolojiler, ekranın alt kısmında chip'ler şeklinde gösterilir
Uygulama yeniden açıldığında, kaydedilmiş tercihler otomatik olarak yüklenir
Geliştirici
Ahmet Talha Biçer
Erciyes Üniversitesi Bilgisayar Mühendisliği
