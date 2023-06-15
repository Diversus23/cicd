#Использовать 1connector

Перем Лог;

// oscript cicd.os obfuscation -file "c:\Temp\000_tempbase\ЗапускПриложений.os" -outfile "c:\Temp\000_tempbase\ЗапускПриложений.os.txt" -APIKey "91A7C..."
// oscript cicd.os obfuscation -file "c:\Temp\000_tempbase\ЗапускПриложений.os" -APIKey "91A7C..."
Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт
    
    ТекстОписаниеКоманды = "Обфускация (запутывание) кода файла общего модуля на языке 1С";
    ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, ТекстОписаниеКоманды);
    Парсер.ДобавитьКоманду(ОписаниеКоманды);
    
    Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды,
        "-file",
        "Исходный файл, который необходимо обфусцировать");
    Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды,
        "-outfile",
        "Куда сохранить обфусцированный файл. Если не задан, то исходный файл будет заменен обфусцированным");
    Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды,
        "-APIKey",
        "API ключ, который можно найти на сайте сервиса. Пример: 23412341A4..12FDA");
    
КонецПроцедуры

Функция ВыполнитьКоманду(Знач Параметры) Экспорт
    
    ВозможныйРезультат = МенеджерКомандПриложения.РезультатыКоманд();
    Лог = ПараметрыСистемы.ПолучитьЛог();
    Лог.Информация("Начало обфускации файла");
    
    Адрес = "https://netlenka.org/Module/ApiClientProtect";
    ИсходныйФайл = Параметры["-file"];
    Если НЕ ЗначениеЗаполнено(ИсходныйФайл) Тогда
        Лог.Ошибка("Не заполнен параметр ""-file"" - файл, который необходимо обфусцировать");
        Возврат ВозможныйРезультат.НеверныеПараметры;
    КонецЕсли;
    ИсходныйФайл = СокрЛП(ИсходныйФайл);
    Если НЕ ФайловыеОперации.ФайлСуществует(ИсходныйФайл) Тогда
        Лог.Ошибка("Файл для обфускации <" + ИсходныйФайл + "> не существует");
        Возврат ВозможныйРезультат.НеверныеПараметры;
    КонецЕсли;
    
    ОбфусцированныйФайл = Параметры["-outfile"];
    Если НЕ ЗначениеЗаполнено(ОбфусцированныйФайл) Тогда
        ОбфусцированныйФайл = ИсходныйФайл;
    КонецЕсли;
    ОбфусцированныйФайл = СокрЛП(ОбфусцированныйФайл);
    
    ApiKey = Параметры["-APIKey"];
    Если НЕ ЗначениеЗаполнено(ApiKey) Тогда
        Лог.Ошибка("Не заполнен параметр ""-APIKey"" - ключ API пользователя на сайте netlenka.org в профиле");
        Возврат ВозможныйРезультат.НеверныеПараметры;
    КонецЕсли;
    
    // public class ApiRequest
    // {
    //     public string ApiKey { get; set; }
    //     public string Text { get; set; }
    //     public bool EncryptStrings { get; set; }
    //     public bool InsertTests { get; set; }
    //     public string ModuleType { get; set; }
    //     public bool ControlFlow { get; set; }
    //     public int ControlFlowLevel { get; set; }
    //     public bool FormatResult { get; set; }
    //     public bool KeepCase { get; set; }
    //     public bool ByteCode { get; set; }
    //     public bool IsImage { get; set; }
    //     public bool CreatePDB { get; set; }
    //     public bool Base64 { get; set; }
    // }
    //
    // public enum ModuleType
    // {
    //     Unknown, CommonModule, FormModule, ManagedFormModule, ObjectModule, SystemModule, CommandModule,
    //     ObjectManager, Image
    // }
    
    ТекстовыйФайл = Новый ТекстовыйДокумент();
    ТекстовыйФайл.Прочитать(ИсходныйФайл, КодировкаТекста.UTF8);
    ДанныеДляОбфускации = "";
    Текст = ТекстовыйФайл.ПолучитьТекст();
    Для Индекс = 1 По СтрЧислоСтрок(Текст) Цикл
        ДанныеДляОбфускации = ДанныеДляОбфускации + СтрПолучитьСтроку(Текст, Индекс) + Символы.ВК + Символы.ПС;
    КонецЦикла;
    
    Структура = Новый Структура();
    Структура.Вставить("ApiKey", ApiKey); // Ключ API
    Структура.Вставить("ModuleType", "CommonModule"); // Общий модуль обрабатываем
    Структура.Вставить("ByteCode", 1); // Обязательный реквизит
    Структура.Вставить("EncryptStrings", 1); // Шифровать строки
    Структура.Вставить("ControlFlow", 1); // Контроль потока
    Структура.Вставить("FormatResult", 0); // Форматировать результат
    Структура.Вставить("KeepCase", 0);
    Структура.Вставить("InsertTests", 1); // Для модулей форм и объектов, включить в код тесты проверки реквизитов
    Структура.Вставить("ControlFlowLevel", 1);
    Структура.Вставить("Text", ДанныеДляОбфускации); // Текст, который нужно обфусцировать
    
    ЗаписьJSON = Новый ЗаписьJSON();
    ЗаписьJSON.УстановитьСтроку();
    ЗаписатьJSON(ЗаписьJSON, Структура);
    ТекстЗапросаJSON = ЗаписьJSON.Закрыть();
    
    Данные = Новый Структура;
    Данные.Вставить("inputData", ТекстЗапросаJSON);
    Лог.Информация("Отправка запроса серверу обфускации");
    Ответ = КоннекторHTTP.Post(Адрес, Данные);
    ЧтениеJSON = Новый ЧтениеJSON();
    ЧтениеJSON.УстановитьСтроку(Ответ.Текст());
    Структура = ПрочитатьJSON(ЧтениеJSON);
    ЧтениеJSON.Закрыть();
    Если Структура.StatusCode = 200 Тогда
        ЧтениеJSON = Новый ЧтениеJSON();
        ЧтениеJSON.УстановитьСтроку(Структура.Content);
        Структура = ПрочитатьJSON(ЧтениеJSON);
        ЧтениеJSON.Закрыть();
        
        Если ВРег(ОбфусцированныйФайл) = ВРег(ИсходныйФайл) Тогда
            УдалитьФайлы(ОбфусцированныйФайл);
        КонецЕсли;
        
        // Записываем в кодировке UTF-8
        ЗТ = Новый ЗаписьТекста(ОбфусцированныйФайл, "windows-1251");
        ЗТ.Закрыть();
        ЗТ = Новый ЗаписьТекста(ОбфусцированныйФайл, "UTF-8", , Истина);
        ЗТ.Записать(Структура.Text);
        ЗТ.Закрыть();
        
        Лог.Информация("Обфускация файла успешно завершена");
    Иначе
        ТекстОшибки = СтрШаблон("Произошла ошибка обфускации %1 (%2)", Структура.Content, Структура.StatusCode);
        Лог.Ошибка(ТекстОшибки);
        Возврат ВозможныйРезультат.ОшибкаВремениВыполнения; // << Ошибка
    КонецЕсли;
    
    Лог.Информация("Окончание процесса обфускации");
    
    Возврат ВозможныйРезультат.Успех;
    
КонецФункции