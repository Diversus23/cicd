﻿#Использовать ".."
#Использовать logos
#Использовать asserts
#Использовать 1commands

// Переменная тестирования
Перем юТест;
// Глобальный лог-файл
Перем Лог;
// Определяем какие тесты можно запускать в облаке, а какие на локальном компьютере.
Перем ЭтоЛокальноеТестирование;
// Путь к статистике
Перем ВключенСборСтатистики;
// Регулярное выражение тестов, которые надо выполнить
Перем РегулярноеВыражениеТестовКоторыеНадоВыполнить;

// BSLLS:LatinAndCyrillicSymbolInWord-off
// BSLLS:UnusedLocalVariable-off

Процедура Инициализация()

	СистемнаяИнформация = Новый СистемнаяИнформация;
	ИмяКомпьютера = ВРег(СистемнаяИнформация.ИмяКомпьютера);
	ЭтоЛокальноеТестирование = ИмяКомпьютера = "SPC" ИЛИ ИмяКомпьютера = "MSI";
	РегулярноеВыражениеТестовКоторыеНадоВыполнить = "";	
	
КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт

	ВключенСборСтатистики = АргументыКоманднойСтроки.Количество() = 0;

КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт

	юТест.УдалитьВременныеФайлы();

КонецПроцедуры

Процедура ЯВыполняюКомандуПродуктаCПередачейПараметров(Знач КомандаТестера, Знач ПараметрыКоманды,
		Знач ОжидаемыйКодВозврата = 0, ТекстВывода = "")
	
	Если Лог.Уровень() >= УровниЛога.Отладка Тогда
		юТест.ВключитьОтладкуВЛогахЗапускаемыхСкриптовOnescript();
	КонецЕсли;

	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;	
	
	ПутьСтартера = ОбъединитьПути(КаталогИсходников(), "src", "actions.os");
	ФайлСтартера = Новый Файл(ПутьСтартера);
	ФайлСтартераСуществует = ФайлСтартера.Существует();
	Ожидаем.Что(ФайлСтартераСуществует,
		"Ожидаем, что скрипт-стартер <actions.os> существует, а его нет. " + ФайлСтартера.ПолноеИмя).Равно(Истина);
	
	КомандаДвижка = "oscript";
	Если ЭтоWindows Тогда
		КомандаДвижка = СтрШаблон("%1 %2", КомандаДвижка, "-encoding=utf-8");
	КонецЕсли;
	Если ВключенСборСтатистики = Истина Тогда
		КомандаДвижка = СтрШаблон("%1 %2", КомандаДвижка, ПараметрСтатистикиДляКомандыОСкрипт());
	КонецЕсли;

	СтрокаКоманды = СтрШаблон("%1 %2 %3 %4", КомандаДвижка, ПутьСтартера, КомандаТестера, ПараметрыКоманды);
	
	Команда = Новый Команда;
	
	Команда.УстановитьСтрокуЗапуска(СтрокаКоманды);
	Команда.УстановитьКодировкуВывода(КодировкаТекста.UTF8);
	КодВозврата = Команда.Исполнить();
	ТекстВывода = Команда.ПолучитьВывод();
	
	Лог.Отладка(ТекстВывода);
	
	Если ОжидаемыйКодВозврата <> Неопределено И КодВозврата <> ОжидаемыйКодВозврата
		ИЛИ Лог.Уровень() <= УровниЛога.Отладка Тогда
		ВывестиТекст(ТекстВывода);
		Ожидаем.Что(КодВозврата, "Код возврата в ЯВыполняюКомандуПродуктаCПередачейПараметров")
		.Равно(ОжидаемыйКодВозврата);
	КонецЕсли;
КонецПроцедуры

Функция ПараметрСтатистикиДляКомандыОСкрипт()

	ОбъектКаталогаСтатистики = ОбъединитьПути(ОбщегоНазначения.КаталогПроекта(), "out");
	Если Не ЗначениеЗаполнено(ОбъектКаталогаСтатистики) Тогда
		Возврат "";
	КонецЕсли;

	Ожидаем.Что(ФайловыеОперации.КаталогСуществует(ОбъектКаталогаСтатистики),
	 	"Каталог статистики должен существовать перед выполнения скрипта OneScript").Равно(Истина);

	МенеджерВременныхФайлов = Новый МенеджерВременныхФайлов;
	МенеджерВременныхФайлов.БазовыйКаталог = ОбъектКаталогаСтатистики;
	ИмяФайлаСтатистики = "stat" + Строка(Новый УникальныйИдентификатор()) + ".json";
	ПутьФайлаСтатистики = ОбъединитьПути(ОбъектКаталогаСтатистики, ИмяФайлаСтатистики);

	Возврат СтрШаблон("-codestat=%1", ПутьФайлаСтатистики);
КонецФункции

// BSLLS:UnusedLocalMethod-off
Процедура ВключитьПоказОтладки()
	Лог.УстановитьУровень(УровниЛога.Отладка);
КонецПроцедуры

Процедура ВыключитьПоказОтладки()
	Лог.УстановитьУровень(УровниЛога.Информация);
КонецПроцедуры
// BSLLS:UnusedLocalMethod-on

Процедура ВывестиТекст(Знач Строка)
	
	Лог.Отладка("");
	Лог.Отладка("  ----------------    ----------------    ----------------  ");
	Лог.Отладка(Строка);
	Лог.Отладка("  ----------------    ----------------    ----------------  ");
	Лог.Отладка("");
	
КонецПроцедуры

Функция КаталогТестовыхФикстур() Экспорт
	Возврат ОбъединитьПути(КаталогТестов(), "fixtures");
КонецФункции

Функция КаталогТестов() Экспорт
	Возврат ОбъединитьПути(КаталогИсходников(), "tests");
КонецФункции

Функция КаталогИсходников() Экспорт
	Возврат ОбъединитьПути(ТекущийСценарий().Каталог, "..");
КонецФункции

Функция ПолучитьТекстИзФайла(ИмяФайла)
	
	ФайлОбмена = Новый Файл(ИмяФайла);
	Данные = "";
	Если ФайлОбмена.Существует() Тогда
		Текст = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
		Данные = Текст.Прочитать();
		Текст.Закрыть();
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

Процедура Тест_Должен_Выполнить_Команду_checksum() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "checksum.txt");
	ПутьФайлаТестаВременный = юТест.ИмяВременногоФайла("txt");
	Текст = ПолучитьТекстИзФайла(ПутьФайлаТеста);
	Текст = СтрЗаменить(Текст, Символы.ПС, "");
	Текст = СтрЗаменить(Текст, Символ(10), "");
	Текст = СтрЗаменить(Текст, Символ(13), "");
	Файл = Новый ЗаписьТекста(ПутьФайлаТестаВременный, КодировкаТекста.UTF8, Символы.ПС, Истина, Символы.ПС);
	Файл.Записать(Текст);
	Файл.Закрыть();

	ЯВыполняюКомандуПродуктаCПередачейПараметров("checksum", "--file " + ПутьФайлаТестаВременный);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_checksum_СОшибкой() Экспорт

	ЯВыполняюКомандуПродуктаCПередачейПараметров("checksum", "", 1);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_obfuscation() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "code.os");
	ПутьФайлаТестаВременный = юТест.ИмяВременногоФайла("txt");
	мПараметры = "--in """ + ПутьФайлаТеста + """"
		+ " --out """ + ПутьФайлаТестаВременный + """";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("obfuscation module", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_changelog() Экспорт
	
	мПараметры = "";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("changelog", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_changelog_init() Экспорт

	ПутьФайлаТеста = юТест.ИмяВременногоФайла("md");
	мПараметры = "--file """ + ПутьФайлаТеста + """";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("changelog init", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_changelog_txt() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.md");
	ПутьФайлаТестаРезультат = юТест.ИмяВременногоФайла("txt");
	ПутьФайлаТестаСравнить = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.txt");
	Команда = "--in ""%1"" --out ""%2"" --format %3";
	мПараметры = СтрШаблон(Команда, ПутьФайлаТеста, ПутьФайлаТестаРезультат, "txt");
	ЯВыполняюКомандуПродуктаCПередачейПараметров("changelog convert", мПараметры);

	Текст1 = ПолучитьТекстИзФайла(ПутьФайлаТестаРезультат);
	Текст2 = ПолучитьТекстИзФайла(ПутьФайлаТестаСравнить);

	Ожидаем.Что(Текст1).Равно(Текст2);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_changelog_txt_version() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.md");
	ПутьФайлаТестаРезультат = юТест.ИмяВременногоФайла("txt");
	ПутьФайлаТестаСравнить = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.txt");
	Команда = "--in ""%1"" --out ""%2"" --format %3 --version %4";
	мПараметры = СтрШаблон(Команда, ПутьФайлаТеста, ПутьФайлаТестаРезультат, "txt", "1.0.0.0");
	ЯВыполняюКомандуПродуктаCПередачейПараметров("changelog convert", мПараметры);

	Текст1 = ПолучитьТекстИзФайла(ПутьФайлаТестаРезультат);
	Текст2 = ПолучитьТекстИзФайла(ПутьФайлаТестаСравнить);

	Ожидаем.Что(Текст1).Равно(Текст2);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_changelog_htmlfull() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.md");
	ПутьФайлаТестаРезультат = юТест.ИмяВременногоФайла("txt");
	ПутьФайлаТестаСравнить = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.full.html");
	Команда = "--in ""%1"" --out ""%2"" --format %3";
	мПараметры = СтрШаблон(Команда, ПутьФайлаТеста, ПутьФайлаТестаРезультат, "htmlfull");
	ЯВыполняюКомандуПродуктаCПередачейПараметров("changelog convert", мПараметры);

	Текст1 = ПолучитьТекстИзФайла(ПутьФайлаТестаРезультат);
	Текст2 = ПолучитьТекстИзФайла(ПутьФайлаТестаСравнить);

	Ожидаем.Что(Текст1).Равно(Текст2);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_changelog_html() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.md");
	ПутьФайлаТестаРезультат = юТест.ИмяВременногоФайла("html");
	ПутьФайлаТестаСравнить = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.html");
	Команда = "--in ""%1"" --out ""%2"" --format %3";
	мПараметры = СтрШаблон(Команда, ПутьФайлаТеста, ПутьФайлаТестаРезультат, "html");
	ЯВыполняюКомандуПродуктаCПередачейПараметров("changelog convert", мПараметры);

	Текст1 = ПолучитьТекстИзФайла(ПутьФайлаТестаРезультат);
	Текст2 = ПолучитьТекстИзФайла(ПутьФайлаТестаСравнить);

	Ожидаем.Что(Текст1).Равно(Текст2);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_actions() Экспорт

	ЯВыполняюКомандуПродуктаCПередачейПараметров("", "");
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_version() Экспорт

	ЯВыполняюКомандуПродуктаCПередачейПараметров("--version", "");
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_autodoc() Экспорт

	ПутьФайлаТестаРезультат = ОбъединитьПути(КаталогИсходников(), "COMMAND.md");
	мПараметры = "--file """ + ПутьФайлаТестаРезультат + """";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("autodoc", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_json() Экспорт

	мПараметры = "";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("json", мПараметры);

КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_json_write_string() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "test.json");
	мПараметры = "--file """ + ПутьФайлаТеста + """ --key ""default.test.string"" --string ""Hello world""";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("json write", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_json_write_number() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "test.json");
	мПараметры = "--action set --file """ + ПутьФайлаТеста + """ --key ""default.test.number"" --number 555";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("json write", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_json_write_boolean() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "test.json");
	мПараметры = "--file """ + ПутьФайлаТеста + """ --key ""default.test.boolean"" --boolean true";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("json write", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_json_read() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "test.json");
	мПараметры = "--file """ + ПутьФайлаТеста + """ --key ""default.test.string"" --errors";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("json read", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_json_del() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "test.json");
	мПараметры = СтрШаблон("--file ""%1"" --action del --key ""default.test.string""", ПутьФайлаТеста);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("json write", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_json_addinarray() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "test.json");
	мПараметры = СтрШаблон("--file ""%1"" --action addinarray --key ""default.test.array"" --str ""%2""",
		ПутьФайлаТеста, "Hello world");	
	ЯВыполняюКомандуПродуктаCПередачейПараметров("json write", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_json_cleararray() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "test.json");
	мПараметры = СтрШаблон("--file ""%1"" --action cleararray --key ""default.test.array""", ПутьФайлаТеста);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("json write", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_json_read_errors() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "test.json");
	мПараметры = "--file """ + ПутьФайлаТеста + """ --key ""default.test.string1"" --errors";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("json read", мПараметры, 1);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_ftp_get() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), "__test");
	мПараметры = "--local " + ПутьФайлаТеста;
	ЯВыполняюКомандуПродуктаCПередачейПараметров("ftp get", мПараметры);
	УдалитьФайлы(ПутьФайлаТеста);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_ftp_put() Экспорт
	
	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), "__test");
	ФайлТеста = ОбъединитьПути(ПутьФайлаТеста, "test.txt");	
	ФайловыеОперации.ОбеспечитьПустойКаталог(ПутьФайлаТеста);

	ТД = Новый ТекстовыйДокумент();
	ТД.ДобавитьСтроку("Hello world");
	ТД.Записать(ФайлТеста);

	мПараметры = СтрШаблон("--local %1 --remote %2 --mask test.txt", ПутьФайлаТеста, "/chatgpt/");
	ЯВыполняюКомандуПродуктаCПередачейПараметров("ftp put", мПараметры);
	УдалитьФайлы(ПутьФайлаТеста);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_ftp_fileexist() Экспорт

	мПараметры = "--file /chatgpt/1_0_0_1.txt";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("ftp fileexists", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_ftp_not_fileexist() Экспорт

	мПараметры = "--file /chatgpt/errors.txt";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("ftp fileexists", мПараметры, 1);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_ftp_delete() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), "__test");
	ФайлТеста = ОбъединитьПути(ПутьФайлаТеста, "test.txt");	
	ФайловыеОперации.ОбеспечитьПустойКаталог(ПутьФайлаТеста);

	ТД = Новый ТекстовыйДокумент();
	ТД.ДобавитьСтроку("Hello world");
	ТД.Записать(ФайлТеста);

	// Копируем в /chatgpt/test.txt
	мПараметры = СтрШаблон("--local %1 --remote %2 --mask test.txt", ПутьФайлаТеста, "/chatgpt/");
	ЯВыполняюКомандуПродуктаCПередачейПараметров("ftp put", мПараметры);
	УдалитьФайлы(ПутьФайлаТеста);

	// Удаляем в /chatgpt/test.txt
	мПараметры = СтрШаблон("--remote %1 --mask test.txt", "/chatgpt/");
	ЯВыполняюКомандуПродуктаCПередачейПараметров("ftp delete", мПараметры);	

	// Проверяем, что файл не существует
	мПараметры = "--file /chatgpt/test.txt";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("ftp fileexists", мПараметры, 1);

КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_infobase_create_file() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), "__test");
	ФайловыеОперации.ОбеспечитьПустойКаталог(ПутьФайлаТеста);
	мПараметры = "--path " + ПутьФайлаТеста;
	ЯВыполняюКомандуПродуктаCПередачейПараметров("infobase create file", мПараметры);
	УдалитьФайлы(ПутьФайлаТеста);

КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_infobase_configcheck() Экспорт

	ПутьИБ = СоздатьВременнуюИБ1С();
	мПараметры = СтрШаблон("--connection /F%1", ПутьИБ);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("infobase configcheck", мПараметры);
	УдалитьФайлы(ПутьИБ);

КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_infobase_configsave() Экспорт

	ИмяФайла = ОбъединитьПути(КаталогВременныхФайлов(), ПолучитьИмяВременногоФайла());
	ПутьИБ = СоздатьВременнуюИБ1С();
	мПараметры = СтрШаблон("--connection /F%1 --file %2", ПутьИБ, ИмяФайла);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("infobase configsave", мПараметры);
	УдалитьФайлы(ПутьИБ);
	УдалитьФайлы(ИмяФайла);

КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_infobase_configload() Экспорт

	ИмяФайла = ОбъединитьПути(КаталогВременныхФайлов(), ПолучитьИмяВременногоФайла());
	ПутьИБ = СоздатьВременнуюИБ1С();
	мПараметры = СтрШаблон("--connection /F%1 --file %2", ПутьИБ, ИмяФайла);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("infobase configsave", мПараметры);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("infobase configload", мПараметры);
	УдалитьФайлы(ПутьИБ);
	УдалитьФайлы(ИмяФайла);

КонецПроцедуры

Функция СоздатьВременнуюИБ1С()
	
	// BSLLS:MissingTemporaryFileDeletion-off
	ПутьИБ = ОбъединитьПути(КаталогВременныхФайлов(), ПолучитьИмяВременногоФайла());
	мПараметры = "--path " + ПутьИБ;
	ЯВыполняюКомандуПродуктаCПередачейПараметров("infobase create file", мПараметры);
	Возврат ПутьИБ;
	// BSLLS:MissingTemporaryFileDeletion-on

КонецФункции

Процедура Тест_Должен_Выполнить_Команду_infobase_dump_restore() Экспорт

	ПутьИБ = СоздатьВременнуюИБ1С();
	ФайлDT = ОбъединитьПути(КаталогВременныхФайлов(), ПолучитьИмяВременногоФайла("dt"));
	мПараметры = СтрШаблон("--file %1 --connection /F%2", ФайлDT, ПутьИБ);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("infobase dump", мПараметры);

	мПараметры = СтрШаблон("--file %1 --connection /F%2", ФайлDT, ПутьИБ);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("infobase restore", мПараметры);

	УдалитьФайлы(ПутьИБ);
	УдалитьФайлы(ФайлDT);

КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_infobase_dumpformat() Экспорт
	
	ПутьИБ = СоздатьВременнуюИБ1С();
	мПараметры = СтрШаблон("--path %1 --connection /F%2", КаталогВременныхФайлов(), ПутьИБ);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("infobase dumpformat", мПараметры);
	УдалитьФайлы(ПутьИБ);

КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_infobase_clearcache() Экспорт
	
	ПутьИБ = СоздатьВременнуюИБ1С();
	мПараметры = СтрШаблон("--connection /F%1", ПутьИБ);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("infobase clearcache", мПараметры);
	УдалитьФайлы(ПутьИБ);

КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs() Экспорт

	мПараметры = "";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_errorsfromfile() Экспорт

	ИмяФайла = ОбъединитьПути(КаталогТестовыхФикстур(), "checksum.txt");
	мПараметры = СтрШаблон("--file %1", ИмяФайла);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs errorsfromfile", мПараметры, 1);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_errorsfromfile_ОшибокНет() Экспорт

	ИмяФайла = ОбъединитьПути(КаталогТестовыхФикстур(), "checksum123456789.txt");
	мПараметры = СтрШаблон("--file %1", ИмяФайла);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs errorsfromfile", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_newpath() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), ПолучитьИмяВременногоФайла());
	ФайловыеОперации.ОбеспечитьПустойКаталог(ПутьФайлаТеста);
	мПараметры = "--path " + ПутьФайлаТеста;
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs newpath", мПараметры);	
	Утверждения.ПроверитьИстину(ФайловыеОперации.КаталогСуществует(ПутьФайлаТеста), "Каталог не создан newpath");
	УдалитьФайлы(ПутьФайлаТеста);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_newemptypath() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), ПолучитьИмяВременногоФайла());
	мПараметры = "--path " + ПутьФайлаТеста + " --empty";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs newpath", мПараметры);	
	Утверждения.ПроверитьИстину(ФайловыеОперации.КаталогСуществует(ПутьФайлаТеста), "Каталог не создан newemptypath");
	УдалитьФайлы(ПутьФайлаТеста);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_newemptypath_exist() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), ПолучитьИмяВременногоФайла());
	ФайловыеОперации.ОбеспечитьПустойКаталог(ПутьФайлаТеста);
	Текст = Новый ТекстовыйДокумент();
	ПутьФайла = ОбъединитьПути(ПутьФайлаТеста, "test.txt");
	Текст.Записать(ПутьФайла);
	мПараметры = "--path " + ПутьФайлаТеста + " --clear";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs newpath", мПараметры);	
	Утверждения.ПроверитьИстину(ФайловыеОперации.КаталогСуществует(ПутьФайлаТеста), "Каталог не создан newemptypath");
	Утверждения.ПроверитьИстину(ФайловыеОперации.ФайлСуществует(ПутьФайла) = Ложь, "Файлы существуют newemptypath");
	УдалитьФайлы(ПутьФайлаТеста);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_newtemppath() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), ПолучитьИмяВременногоФайла());
	ФайловыеОперации.ОбеспечитьПустойКаталог(ПутьФайлаТеста);
	мПараметры = "--path " + ПутьФайлаТеста;
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs newtemppath", мПараметры);	
	Утверждения.ПроверитьИстину(ФайловыеОперации.КаталогСуществует(ПутьФайлаТеста), "Каталог не создан newtemppath");
	УдалитьФайлы(ПутьФайлаТеста);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_newtempfile() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), "test");
	мПараметры = "--path " + ПутьФайлаТеста + " --ext txt";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs newtempfile", мПараметры);
	УдалитьФайлы(ПутьФайлаТеста);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_delete() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), "test");
	мПараметры = "--path " + ПутьФайлаТеста;
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs delete", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_deleteold() Экспорт
	
	КаталогФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), "test");
	ФайловыеОперации.КопироватьФайлы(КаталогТестовыхФикстур(), КаталогФайлаТеста);
	мПараметры = СтрШаблон("--path %1 --type min --val 1 --delifempty --recursive", КаталогФайлаТеста);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs deleteold", мПараметры);
	УдалитьФайлы(КаталогФайлаТеста);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_deletekeep() Экспорт

	КаталогФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), "test");
	ФайловыеОперации.КопироватьФайлы(КаталогТестовыхФикстур(), КаталогФайлаТеста);
	мПараметры = СтрШаблон("--path %1 --count 1", КаталогФайлаТеста);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs deletekeep", мПараметры);
	УдалитьФайлы(КаталогФайлаТеста);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_fileexists() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.md");
	мПараметры = "--file " + ПутьФайлаТеста;
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs fileexists", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_addcontent() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), ПолучитьИмяВременногоФайла());
	ДобавленныйТекст = "Hello world";
	мПараметры = СтрШаблон("--file %1 --text ""%2""", ПутьФайлаТеста, ДобавленныйТекст);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs addcontent", мПараметры);
	Текст = ФайловыеОперации.ПрочитатьТекстФайла(ПутьФайлаТеста);
	Утверждения.ПроверитьИстину(Текст = ДобавленныйТекст, "Тексты не равны (addcontent) " 
	 	+ Текст + " <> " + ДобавленныйТекст);
	УдалитьФайлы(ПутьФайлаТеста);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_copy() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), "test");
	мПараметры = СтрШаблон("--from %1 --to %2", КаталогТестовыхФикстур(), ПутьФайлаТеста);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs copy", мПараметры);
	УдалитьФайлы(ПутьФайлаТеста);

КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_findcopy() Экспорт

	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), "test");
	мПараметры = СтрШаблон("--from %1 --to %2 --mask %3", КаталогТестовыхФикстур(), ПутьФайлаТеста, "*.html");
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs findcopy", мПараметры);
	УдалитьФайлы(ПутьФайлаТеста);

КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_copy_move() Экспорт

	ПутьФайлаТеста1 = ОбъединитьПути(КаталогВременныхФайлов(), "test1");
	мПараметры = СтрШаблон("--from %1 --to %2 --recursive", КаталогТестовыхФикстур(), ПутьФайлаТеста1);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs copy", мПараметры);

	ПутьФайлаТеста2 = ОбъединитьПути(КаталогВременныхФайлов(), "test2");
	мПараметры = СтрШаблон("--from %1 --to %2 --recursive --move", ПутьФайлаТеста1, ПутьФайлаТеста2);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs copy", мПараметры);
	УдалитьФайлы(ПутьФайлаТеста1);
	УдалитьФайлы(ПутьФайлаТеста2);

КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_copy_self_folder() Экспорт

	мПараметры = СтрШаблон("--from %1 --to %1 --recursive", КаталогТестовыхФикстур());
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs copy", мПараметры);

КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_copy_self_files() Экспорт

	ПутьФайловКопирования = ОбъединитьПути(КаталогТестовыхФикстур(), "*.html");
	мПараметры = СтрШаблон("--from %1 --to %2 --recursive", ПутьФайловКопирования, КаталогТестовыхФикстур());
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs copy", мПараметры);

КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_fs_copy_mask() Экспорт

	ПутьФайловКопирования = ОбъединитьПути(КаталогТестовыхФикстур(), "*.html");
	ПутьФайлаТеста = ОбъединитьПути(КаталогВременныхФайлов(), "test");	
	мПараметры = СтрШаблон("--from %1 --to %2 --recursive", ПутьФайловКопирования, ПутьФайлаТеста);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("fs copy", мПараметры);
	УдалитьФайлы(ПутьФайлаТеста);

КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_zip() Экспорт

	мПараметры = "";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("zip", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_edt() Экспорт

	мПараметры = "";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("edt", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_infobase() Экспорт

	мПараметры = "";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("infobase", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_infobase_vanessaautomation() Экспорт

	мПараметры = "";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("infobase vanessaautomation", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_http_get() Экспорт

	ПутьФайла = юТест.ИмяВременногоФайла("json");
	мПараметры = СтрШаблон("--url ""%1"" --p1 ""%2"" --v1 ""%3"" --format json --out ""%4""",
		"https://connectorhttp.ru/anything/params",
		"name",
		"Иванов",
		ПутьФайла);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("http get", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_http() Экспорт

	мПараметры = "";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("http", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_infobase_create() Экспорт

	мПараметры = "";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("infobase create", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_edt_export() Экспорт

	мПараметры = "";
	ЯВыполняюКомандуПродуктаCПередачейПараметров("edt export", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Проверку_ПеречислениеНеНайдено() Экспорт

	Попытка
		Значение = Перечисления.МоеПеречисление.ДаНет;
	Исключение
		Текст = ИнформацияОбОшибке().Описание;
		Утверждения.ПроверитьИстину(Найти(Текст, "Свойство объекта не обнаружено") > 0, "Получено исключение " + Текст);
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Проверку_ПеречислениеПоИмени() Экспорт

	Значение = Перечисления.Значение("ФорматChangeLog.ПолныйHTML");
	Утверждения.ПроверитьИстину(Значение = Перечисления.ФорматChangeLog.ПолныйHTML, 
		"Не совпадает перечисление " + Значение + " и " + Перечисления.ФорматChangeLog.ПолныйHTML);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Проверку_ПеречислениеПоИмениНеНайдено() Экспорт

	Попытка
		Значение = Перечисления.Значение("ФорматChangeLog.ПолныйHTMLНеНайден");
	Исключение
		Текст = ИнформацияОбОшибке().Описание;
		Утверждения.ПроверитьИстину(Найти(Текст, "Не найдено значение") > 0, "Получено исключение " + Текст);
		Возврат;
	КонецПопытки;	
		
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_zip_add_ДобавилиОдинФайлВАрхив() Экспорт

	ПутьАрхива = юТест.ИмяВременногоФайла("zip");
	МаскаФайлов = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.md");
	мПараметры = СтрШаблон("--file ""%1"" --mask ""%2""", ПутьАрхива, МаскаФайлов);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("zip add", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_zip_add_ДобавилиДваФайлаВАрхив() Экспорт

	ПутьАрхива = юТест.ИмяВременногоФайла("zip");
	МаскаФайлов = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.md") + ";"
		+ ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.txt");
	мПараметры = СтрШаблон("--file ""%1"" --mask ""%2""", ПутьАрхива, МаскаФайлов);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("zip add", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_zip_add_ДобавилиПоМаске() Экспорт

	ПутьАрхива = юТест.ИмяВременногоФайла("zip");
	МаскаФайлов = ОбъединитьПути(КаталогТестовыхФикстур(), "*.html");
	мПараметры = СтрШаблон("--file ""%1"" --mask ""%2""", ПутьАрхива, МаскаФайлов);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("zip add", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_zip_extract() Экспорт

	ПутьАрхива = юТест.ИмяВременногоФайла("zip");
	ДобавляемыеФайлы = ОбъединитьПути(КаталогТестовыхФикстур(), "changelog.html");
	МассивФайлов = Новый Массив();
	МассивФайлов.Добавить(ДобавляемыеФайлы);
	АрхиваторФайлов = Новый Архиватор(ПутьАрхива);
	АрхиваторФайлов.Добавить(МассивФайлов);	
	
	КудаРаспаковать = ОбъединитьПути(КаталогВременныхФайлов(), "folder");
	мПараметры = СтрШаблон("--file ""%1"" --path ""%2""", ПутьАрхива, КудаРаспаковать);
	ЯВыполняюКомандуПродуктаCПередачейПараметров("zip extract", мПараметры);
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_edt_versionconfig_program() Экспорт
	
	Версия = РаботаEDT.ВерсияКонфигурацииИзПроекта(КаталогТестовыхФикстур());
	Утверждения.ПроверитьИстину(Версия = "1.0.0.13", "edt_versionconfig_program версия не совпадает");
	
КонецПроцедуры

Процедура Тест_Должен_Выполнить_Команду_edt_versionconfig_project() Экспорт

	мПараметры = СтрШаблон("--project ""%1""", КаталогТестовыхФикстур());
	ЯВыполняюКомандуПродуктаCПередачейПараметров("edt versionconfig", мПараметры);
	
КонецПроцедуры

Процедура ДобавитьТест(СписокТестов, ИмяТеста)
	
	Если НЕ ПустаяСтрока(РегулярноеВыражениеТестовКоторыеНадоВыполнить) И ЭтоЛокальноеТестирование = Истина Тогда
		МассивПоиска = ОбщегоНазначения.НайтиПоРегулярномуВыражению(ИмяТеста, 
			РегулярноеВыражениеТестовКоторыеНадоВыполнить);
		ТестНайден = МассивПоиска.Количество() > 1;
		Если ТестНайден Тогда
			Лог.Информация("Тест <%1> будет выполнен", ИмяТеста);
		КонецЕсли;
	Иначе
		ТестНайден = Истина;
	КонецЕсли;

	Если ТестНайден Тогда
		СписокТестов.Добавить(ИмяТеста);	
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьСписокТестов(Тестирование) Экспорт
	
	юТест = Тестирование;

	РегулярноеВыражениеТестовКоторыеНадоВыполнить = "";

	// BSLLS:CommentedCode-off
	СписокТестов = Новый Массив;
	// Код
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Проверку_ПеречислениеНеНайдено");	
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Проверку_ПеречислениеПоИмени");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Проверку_ПеречислениеПоИмениНеНайдено");
	// Действия
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_actions");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_version");	
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_autodoc");	
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_checksum");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_checksum_СОшибкой");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_changelog");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_changelog_init");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_changelog_txt");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_changelog_txt_version");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_changelog_html");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_changelog_htmlfull");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_json");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_json_write_string");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_json_write_number");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_json_write_boolean");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_json_read");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_json_read_errors");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_json_del");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_json_addinarray");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_json_cleararray");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_copy");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_findcopy");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_copy_move");
	// Не работают
	// ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_copy_self_folder");
	// ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_copy_self_files");
	// ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_copy_mask");
	//
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_errorsfromfile");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_errorsfromfile_ОшибокНет");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_newemptypath");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_newemptypath_exist");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_newpath");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_newtemppath");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_fileexists");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_newtempfile");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_delete");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_deleteold");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_deletekeep");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_fs_addcontent");	
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_zip");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_zip_add_ДобавилиОдинФайлВАрхив");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_zip_add_ДобавилиДваФайлаВАрхив");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_zip_add_ДобавилиПоМаске");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_zip_extract");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_edt");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_edt_versionconfig_program");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_edt_versionconfig_project");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_infobase");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_infobase_create");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_infobase_vanessaautomation");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_http");
	ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_http_get");

	Если ЭтоЛокальноеТестирование Тогда		
		ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_ftp_get");
		ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_ftp_put");
		ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_ftp_delete");
		ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_ftp_fileexist");
		ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_ftp_not_fileexist");
		ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_obfuscation");
		ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_infobase_create_file");
		ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_infobase_dump_restore");
		ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_infobase_dumpformat");
		ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_infobase_configcheck");
		ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_infobase_configsave");
		ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_infobase_configload");
		ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_infobase_clearcache");
		// Написать тест "Тест_Должен_Выполнить_Команду_infobase_extension_save"
		// Написать тест "Тест_Должен_Выполнить_Команду_infobase_extension_load"
		// Написать тест "Тест_Должен_Выполнить_Команду_infobase_extension_loadfromsource"
		// Написать тест "Тест_Должен_Выполнить_Команду_infobase_extension_savetosource"
		// Написать тест "Тест_Должен_Выполнить_Команду_infobase_extension_update"
		// Написать тест "Тест_Должен_Выполнить_Команду_infobase_create_server"
		// Написать тест "Тест_Должен_Выполнить_Команду_infobase_distrib"
		// Написать тест "Тест_Должен_Выполнить_Команду_infobase vanessaautomation dbgson"
		// Написать тест "Тест_Должен_Выполнить_Команду_infobase vanessaautomation dbgsoff"
		// Написать тест "Тест_Должен_Выполнить_Команду_edt_sourcetoxml1c"
		// Написать тест "Тест_Должен_Выполнить_Команду_infobase_vanessaautomation_run"
		//ДобавитьТест(СписокТестов, "Тест_Должен_Выполнить_Команду_infobase_create_file");
	КонецЕсли;	
	// BSLLS:CommentedCode-on
	
	Возврат СписокТестов;
	
КонецФункции

Инициализация();
Лог = Логирование.ПолучитьЛог("actions1c.tests");

Отладка = Ложь;
Если Отладка Тогда	
	ВключитьПоказОтладки();
КонецЕсли;

// BSLLS:LatinAndCyrillicSymbolInWord-on
// BSLLS:UnusedLocalVariable-on