#Использовать logos

Перем КорневойПутьПроекта Экспорт;
Перем ЭтоWindows Экспорт;
Перем Лог Экспорт;
Перем ЛогПриложения Экспорт;

//	Возвращает идентификатор лога приложения
//
// Возвращаемое значение:
//   Строка   - Значение идентификатора лога приложения
//
Функция ИмяЛогаСистемы() Экспорт
	
	Возврат "oscript.app." + ИмяПриложения();
	
КонецФункции // ИмяЛогаСистемы

//	Возвращает текущую версию продукта
//
// Возвращаемое значение:
//   Строка   - Значение текущей версии продукта
//
Функция Версия() Экспорт
	
	Версия = "0.0.1";
	Возврат Версия;
	
КонецФункции // ВерсияПродукта()

// Возвращает имя продукта
//
//  Возвращаемое значение:
//   Строка - имя продукта
//
Функция ИмяПриложения() Экспорт
	
	Возврат "actions";
	
КонецФункции

Функция ИмяФайлаНастроек() Экспорт
	
	Возврат "env.json";
	
КонецФункции

Функция ПолучитьЛог() Экспорт
	
	Возврат Лог();
	
КонецФункции

// Функция - возвращает текущий уровень лога приложения
//
// Возвращаемое значение:
//  Строка      - текущий уровень лога приложения
//
Функция УровеньЛога() Экспорт

	Возврат ЛогПриложения.Уровень();

КонецФункции // УровеньЛога()

// Процедура - включает режим отладки
//
// Параметры:
//	РежимОтладки    - Булево     - Истина - включить режим отладки
//
Процедура УстановитьРежимОтладки(Знач РежимОтладки) Экспорт
	
	Если РежимОтладки Тогда
		
		Лог().УстановитьУровень(УровниЛога.Отладка);

	КонецЕсли;
	
КонецПроцедуры // УстановитьРежимОтладки()

// Функция - при необходимости, инициализирует и возвращает объект управления логированием
//
// Возвращаемое значение:
//  Объект      - объект управления логированием
//
Функция Лог() Экспорт
	
	Если ЛогПриложения = Неопределено Тогда
		ЛогПриложения = Логирование.ПолучитьЛог(ИмяЛогаПриложения());
	КонецЕсли;

	Возврат ЛогПриложения;

КонецФункции // Лог()

// Функция - возвращает имя лога приложения
//
// Возвращаемое значение:
//  Строка      - имя лога приложения
//
Функция ИмяЛогаПриложения() Экспорт

	Возврат "oscript.app." + ИмяПриложения();

КонецФункции // ИмяЛогаПриложения()