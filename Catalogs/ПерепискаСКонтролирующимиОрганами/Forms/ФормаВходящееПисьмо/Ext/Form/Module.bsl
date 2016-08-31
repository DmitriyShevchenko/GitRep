﻿&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Вложения.ЗагрузитьЗначения(ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ПолучитьСписокВложений(Объект.Ссылка));
	
	Элементы.Вложения.Заголовок = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ФорматированноеПредставлениеСпискаВложений(Вложения.ВыгрузитьЗначения());
	Заголовок = Объект.Наименование;
	
	УправлениеФормой(ЭтаФорма);
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСохранитьВложения(Команда)
	
	СохранитьВложения();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтветить(Команда)
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("КомандаОтветитьЗавершение", ЭтотОбъект);
		ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	Иначе
		КонтекстЭДОКлиент.СоздатьПисьмоОтвет(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтветитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	КонтекстЭДОКлиент.СоздатьПисьмоОтвет(Объект.Ссылка);

КонецПроцедуры

&НаКлиенте
Процедура ВложенияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИмяФайла = НавигационнаяСсылкаФорматированнойСтроки;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ДополнительныеПараметры = Новый Структура("ИмяФайла", ИмяФайла);
		ОписаниеОповещения = Новый ОписаниеОповещения("ВложенияОбработкаНавигационнойСсылкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	Иначе
		ОбработатьВложениеНавигационнойСсылки(ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияОбработкаНавигационнойСсылкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	ИмяФайла = ДополнительныеПараметры.ИмяФайла;
	ОбработатьВложениеНавигационнойСсылки(ИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВложениеНавигационнойСсылки(ИмяФайла)
	
	РасширениеФайла = ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ИмяФайла);
	Если НРег(РасширениеФайла) = "txt" Тогда
		Результат = ПолучитьТекстовоеВложение(Объект.Ссылка, ИмяФайла);
		Если Результат = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вложение с именем 
			|%1
			|не обнаружено.'"), ИмяФайла));
		Иначе
			ПоказатьЗначение(, Результат);
		КонецЕсли;
	Иначе
		Результат = ПолучитьВложениеНаСервере(Объект.Ссылка, ИмяФайла, УникальныйИдентификатор);
		Если Результат = Неопределено Тогда
			ПоказатьПредупреждение(,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вложение с именем 
			|%1
			|не обнаружено.'"), ИмяФайла));
		Иначе
			ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(
				Результат, 
				ОбщегоНазначенияЭДКОКлиентСервер.ЗаменитьЗапрещенныеСимволыВИмениФайла(ИмяФайла));
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьВложения()
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("СохранитьВложенияЗавершение", ЭтотОбъект);
		ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	Иначе
		МассивИменВложений = Новый Массив;
		Для Каждого Элемент Из Вложения Цикл
			МассивИменВложений.Добавить(Элемент.Значение.ИмяФайла);
		КонецЦикла;
		
		Если МассивИменВложений.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		МассивОписанийПолучаемыеФайлы = ПолучитьМассивОписанийФайловВложений(
			Объект.Ссылка, МассивИменВложений, УникальныйИдентификатор);
			
		ОперацииСФайламиЭДКОКлиент.СохранитьФайлы(МассивОписанийПолучаемыеФайлы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВложенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	МассивИменВложений = Новый Массив;
	Для Каждого Элемент Из Вложения Цикл
		МассивИменВложений.Добавить(Элемент.Значение.ИмяФайла);
	КонецЦикла;
	
	Если МассивИменВложений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивОписанийПолучаемыеФайлы = ПолучитьМассивОписанийФайловВложений(
		Объект.Ссылка, МассивИменВложений, УникальныйИдентификатор);
	
	ОперацииСФайламиЭДКОКлиент.СохранитьФайлы(МассивОписанийПолучаемыеФайлы);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМассивОписанийФайловВложений(Ссылка, МассивИменВложений, Идентификатор)
	
	МассивОписаний = Новый Массив;
	
	Для Каждого ИмяВложения Из МассивИменВложений Цикл 
		АдресДанных = ПолучитьВложениеНаСервере(Ссылка, ИмяВложения, Идентификатор);
		Если ЗначениеЗаполнено(АдресДанных) Тогда 
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(
				ОбщегоНазначенияЭДКОКлиентСервер.ЗаменитьЗапрещенныеСимволыВИмениФайла(ИмяВложения), 
				АдресДанных); 
			МассивОписаний.Добавить(ОписаниеФайла);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат МассивОписаний;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	ПрорисоватьСтатус(Форма);
	
	ЕстьВложения = Форма.Вложения.Количество() > 0;
	
	Элементы.КомандаСохранитьВложения.Видимость = ЕстьВложения;
	Элементы.ЗаголовокВложения.Видимость = ЕстьВложения;
	Элементы.Вложения.Видимость = ЕстьВложения;
	
	Элементы.Содержание.Видимость = ЗначениеЗаполнено(Объект.Содержание);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТекстовоеВложение(Ссылка, ИмяФайла)
	
	Возврат Справочники.ПерепискаСКонтролирующимиОрганами.ПолучитьТекстовоеВложение(Ссылка, ИмяФайла);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВложениеНаСервере(Ссылка, ИмяФайла, УникальныйИдентификатор)
	
	Возврат Справочники.ПерепискаСКонтролирующимиОрганами.ПолучитьВложениеНаСервере(Ссылка, ИмяФайла, УникальныйИдентификатор);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПрорисоватьСтатус(Форма)
	
	ВидКонтролирующегоОргана = ИмяТекущегоТипаПолучателя(Форма.Объект.Тип);
	
	ПараметрыПрорисовкиПанелиОтправки = ДокументооборотСКОВызовСервера.ПараметрыПрорисовкиПанелиОтправки(Форма.Объект.Ссылка, Форма.Объект.Организация, ВидКонтролирующегоОргана);
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПрименитьПараметрыПрорисовкиПанелиОтправки(Форма, ПараметрыПрорисовкиПанелиОтправки);
	
	Форма.Элементы.СостояниеОтправки.Видимость = Ложь;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяТекущегоТипаПолучателя(ТипПолучателя)
	
	Если ЗначениеЗаполнено(ТипПолучателя) Тогда
		Если ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСФНС") Тогда
			ВидКонтролирующегоОргана = "ФНС";
		ИначеЕсли ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСПФР") Тогда
			ВидКонтролирующегоОргана = "ПФР";
		ИначеЕсли ТипПолучателя = ПредопределенноеЗначение("Перечисление.ТипыПерепискиСКонтролирующимиОрганами.ПерепискаСФСГС") Тогда
			ВидКонтролирующегоОргана = "ФСГС";
		КонецЕсли;
	Иначе
		Возврат "ФНС";
	КонецЕсли;
	
	Возврат ВидКонтролирующегоОргана;
	
КонецФункции

#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтаФорма, ИмяТекущегоТипаПолучателя(ЭтаФорма.Объект.Тип));
КонецПроцедуры

#КонецОбласти