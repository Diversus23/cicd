﻿#Использовать coloratos

// Есть ли ошибки при проверке
Перем ЕстьОшибки;

#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
    
КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ПроверитьУстановкуПрограммы();
    
КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьУстановкуПрограммы()
	
	ЕстьОшибки = Ложь;

	ЦветнойВывод.ВывестиСтроку("================================================", "Синий");
	ЦветнойВывод.ВывестиСтроку("Проверка программ необходимых для работы actions", "Синий");
	ЦветнойВывод.ВывестиСтроку("================================================", "Синий");

	ДобавитьИнформацию(Работа1С.ПроверитьУстановку1C(),
	 	"1С",
	 	"Приложение 1С не установлено. Нельзя работать с 1С => Установите 1С:Предприятие 8.3",
		"https://releases.1c.ru/project/Platform83");

	ДобавитьИнформацию(РаботаEDT.ПроверитьУстановкуEDT(),
		"ring",
		"Нельзя конвертировать исходный код EDT в 1С => Установите EDT",
		"https://releases.1c.ru/project/DevelopmentTools10");

	ДобавитьИнформацию(РаботаEDT.ПроверитьУстановкуJava(),
		"java",
		"Нельзя конвертировать исходный код EDT в 1С => Установите LibericaJDK",
		"https://releases.1c.ru/project/Liberica11FullJDK");

	ДобавитьИнформацию(ОбщегоНазначения.НайтиПриложениеВСистеме("sonar-scanner"),
		"sonar-scanner",
		"Не сможете проверять качество кода => Установите sonar и sonar-scanner",
		"https://github.com/Daabramov/Sonarqube-for-1c-docker/ и https://github.com/SonarSource/sonar-scanner-cli");

	ДобавитьИнформацию(ОбщегоНазначения.НайтиПриложениеВСистеме("aws"),
		"aws-cli",
		"Пайплайны содержащий копирование в S3 не смогут работать => Установите aws-cli",
		"https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html");		

	ДобавитьИнформацию(ОбщегоНазначения.НайтиПриложениеВСистеме("allure"),
		"allure",
		"Если используете тестирование не сможете смотреть красивые тесты => Установите allure",
		"https://qameta.io/allure-report/");

	ДобавитьИнформацию(ОбщегоНазначения.НайтиПриложениеВСистеме("Coverage41C"),
		"Coverage41C",
		"Если используете тестирование не сможете посчитать покрытие кода => Установите Coverage41C",
		"https://github.com/1c-syntax/Coverage41C/releases");
	ЦветнойВывод.ВывестиСтроку("================================================", "Синий");

	Если ЕстьОшибки = Истина Тогда
		ЦветнойВывод.ВывестиСтроку("Не все проверки пройдены", "Желтый");
	Иначе
		ЦветнойВывод.ВывестиСтроку("Все проверки пройдены", "Зеленый");
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьИнформацию(УсловиеВыполнено, ИмяПриложения, ТекстНеВыполнено, Ссылка = "")
	
	Текст = "Приложение " + ИмяПриложения;
	Если УсловиеВыполнено = Истина Тогда 
		Текст = "([+]|#color=Зеленый) " + Текст + " установлено";
	Иначе
		Текст = "([-]|#color=Красный) " + Текст + " не установлено. " + ТекстНеВыполнено;
		Если НЕ ПустаяСтрока(Ссылка) Тогда
			Текст = Текст + ". " + "(" + Ссылка + "|#color=Желтый)";
		КонецЕсли;
		ЕстьОшибки = Истина;
	КонецЕсли;

	ЦветнойВывод.ВывестиСтроку(Текст, "Белый");

КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции