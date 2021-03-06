﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


#Область ПрограммныйИнтерфейс

Функция ПолучитьТекстовоеВложение(Ссылка, ИмяФайла) Экспорт
	
	// получаем вложение
	СтрВложения = КонтекстЭДО().ПолучитьВложения(Ссылка, ИмяФайла);
	Если СтрВложения.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	СтрВложение = СтрВложения[0];
	
	// сохраняем вложение на диск
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	СтрВложение.Данные.Получить().Записать(ИмяВременногоФайла);
	
	// считываем при помощи ЧтениеТекста, чтобы автоматически распозналась кодировка UTF? или ANSI
	ОбъектЧтение = Новый ЧтениеТекста(ИмяВременногоФайла);
	СтрТекст = ОбъектЧтение.Прочитать();
	ОбъектЧтение.Закрыть();
	
	// удаляем временный файл
	УдалитьФайлы(ИмяВременногоФайла);
	
	Возврат СтрТекст;
	
КонецФункции

Функция ПолучитьВложениеНаСервере(Ссылка, ИмяФайла, Идентификатор) Экспорт
	
	СтрВложения = КонтекстЭДО().ПолучитьВложения(Ссылка, ИмяФайла);
	Если СтрВложения.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Вложение = СтрВложения[0];
	
	Возврат ПоместитьВоВременноеХранилище(Вложение.Данные.Получить(), Идентификатор);

КонецФункции

#КонецОбласти
	
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	// инициализируем контекст ЭДО - модуль обработки
	ТекстСообщения = "";
	КонтекстЭДО = КонтекстЭДО();
	
	СтандартнаяОбработка = Ложь;
	Если ВидФормы = "ФормаСписка" ИЛИ ВидФормы = "ФормаВыбора" Тогда
		ВыбраннаяФорма = "ФормаСписка";
	ИначеЕсли Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ)
		И Параметры.Ключ.Статус = Перечисления.СтатусыПисем.Полученное Тогда
		ВыбраннаяФорма = "ФормаВходящееПисьмо";
	Иначе
		ВыбраннаяФорма = "ФормаИсходящееПисьмо";
	КонецЕсли;
	
	КонтекстЭДО.ОбработкаПолученияФормы("Справочник", "ПерепискаСКонтролирующимиОрганами", ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КонтекстЭДО()
	
	Возврат ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
КонецФункции

#КонецОбласти

#КонецЕсли