﻿&НаКлиенте
Перем КонтекстЭДОКлиент;

&НаСервере
Функция ПолучитьВложениеНаСервере(ИмяФайла)
	
	Результат = Новый Структура("ТекстПредупреждения, АдресДанных");
	
	ТекстСообщения = "";
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДОСервер = Неопределено Тогда 
		Результат.ТекстПредупреждения = ТекстСообщения;
		Возврат Результат;
	КонецЕсли;
	
	// получаем вложение
	СтрВложения = КонтекстЭДОСервер.ПолучитьФайлыДокументовРеализацииПолномочийНалоговыхОрганов(Объект.Ссылка, ИмяФайла);
	Если СтрВложения.Количество() = 0 Тогда
		Результат.ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Вложение с именем  %1 не обнаружено.'"), Символ(34) + ИмяФайла + Символ(34));
		Возврат Результат;
	КонецЕсли;
	
	Вложение = СтрВложения[0];
	
	Адрес = ПоместитьВоВременноеХранилище(Вложение.Данные.Получить(), УникальныйИдентификатор);
	Результат.АдресДанных = Адрес;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура КомандаВыгрузитьВложения(Команда)
	
	СохранитьВложения();

КонецПроцедуры

&НаКлиенте
Процедура СохранитьВложения()
	
	МассивИменВложений = Новый Массив;
	Для Каждого Элемент Из Вложения Цикл
		МассивИменВложений.Добавить(Элемент.Значение.ИмяФайла);
	КонецЦикла;
	
	Если МассивИменВложений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивОписанийПолучаемыеФайлы = ПолучитьМассивОписанийФайловВложений(МассивИменВложений);
	ОперацииСФайламиЭДКОКлиент.СохранитьФайлы(МассивОписанийПолучаемыеФайлы);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = Параметры.Ключ.Пустая();
	Если ЭтоНовый Тогда
		ТекстПредупреждения = НСтр("ru = 'Копирование входящих сообщений запрещено!'");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// инициализируем контекст ЭДО - модуль обработки
	ТекстСообщения = "";
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДОСервер = Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	ОпределитьВидДокумента(КонтекстЭДОСервер);
	УправлениеЭУ(КонтекстЭДОСервер);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда 
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда 
		Закрыть();
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивОписанийФайловВложений(МассивИменВложений)
	
	МассивОписаний = Новый Массив;
	
	Для Каждого ИмяВложения Из МассивИменВложений Цикл 
		Результат = ПолучитьВложениеНаСервере(ИмяВложения);
		Если ЗначениеЗаполнено(Результат.АдресДанных) Тогда 
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ИмяВложения, Результат.АдресДанных); 
			МассивОписаний.Добавить(ОписаниеФайла);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат МассивОписаний;
	
КонецФункции

&НаКлиенте
Процедура КомандаСоздатьОтвет(Команда)
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ЗапретитьСозданиеПисьмаВОтветНаТребованиеПоДекларации", Истина);
			
	КонтекстЭДОКлиент.СоздатьОтветНаДокументРеализацииПолномочий(Объект.Ссылка, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// При записи ответа необходимо перерисовать количество ответов в панели требования. 
	Если ИмяСобытия = "Запись_ОписиИсходящихДокументовВНалоговыеОрганы" 
		И ТипЗнч(Источник) = Тип("СправочникСсылка.ОписиИсходящихДокументовВНалоговыеОрганы")
		ИЛИ	ИмяСобытия = "Запись_ПоясненияКДекларацииПоНДС" 
		И ТипЗнч(Источник) = Тип("ДокументСсылка.ПоясненияКДекларацииПоНДС")
		ИЛИ	ИмяСобытия = "Запись_ПерепискаСКонтролирующимиОрганами" 
		И ТипЗнч(Источник) = Тип("СправочникСсылка.ПерепискаСКонтролирующимиОрганами") Тогда
		
		ПрорисоватьСтатус();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ДокументыРеализацииПолномочийНалоговыхОрганов", , Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Функция ПрорисоватьСтатус()
	
	ПараметрыПрорисовкиПанелиОтправки = ДокументооборотСКОВызовСервера.ПараметрыПрорисовкиПанелиОтправки(Объект.Ссылка, Объект.Организация, "ФНС");
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПрименитьПараметрыПрорисовкиПанелиОтправки(ЭтаФорма, ПараметрыПрорисовкиПанелиОтправки);
	ПрорисоватьПанельПриема();
			
КонецФункции

&НаСервере
Процедура ПрорисоватьПанельПриема()
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	ТекущееСостояниеОтправки = КонтекстЭДОСервер.ТекущееСостояниеОтправки(Объект.Ссылка, Перечисления.ТипыКонтролирующихОрганов.ФНС);

	ГруппаКнопкиПриемаВидимость 	= Ложь;
	
	Если ТекущееСостояниеОтправки <> Неопределено Тогда
		ТекущийЭтапОтправки = ТекущееСостояниеОтправки.ТекущийЭтапОтправки;
		Если ТекущийЭтапОтправки <> Неопределено Тогда
			
			СостояниеСдачиОтчетности = ТекущийЭтапОтправки.СостояниеСдачиОтчетности;
			
			ГруппаКнопкиПриемаВидимость = (СостояниеСдачиОтчетности = Перечисления.СостояниеСдачиОтчетности.ТребуетсяПодтверждениеПриема);
			
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаПанельПриема.Видимость = ГруппаКнопкиПриемаВидимость;
	Элементы.ОтступПередКнопкойОбновитьОтправку.Видимость 	= Истина;
	
	Если ЭтоТребованиеФНС Тогда
		
		Элементы.ЗаголовокНеотправленныхСообщений.Заголовок = 
			НСтр("ru = 'Оператору не отправлено извещение о получении документа'");
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПодтвердитьПрием(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПослеПодтвержденияПриемаИлиОтказаВПриеме", 
		ЭтотОбъект);
		
	КонтекстЭДОКлиент.СоздатьРезультатПриемаВходящейОписиИнтерактивноПоДокументуОписи(Объект.Ссылка, Истина, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтказатьВПриеме(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПослеПодтвержденияПриемаИлиОтказаВПриеме", 
		ЭтотОбъект);
	
	КонтекстЭДОКлиент.СоздатьРезультатПриемаВходящейОписиИнтерактивноПоДокументуОписи(Объект.Ссылка, Ложь, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СсылкаСрокиНажатие(Элемент)
	
	ОткрытьФорму("Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов.Форма.ФормаСрокиПредставления", , ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИмяФайла = НавигационнаяСсылкаФорматированнойСтроки;
	
	Результат = ПолучитьВложениеНаСервере(ИмяФайла);
	Если ЗначениеЗаполнено(Результат.ТекстПредупреждения) Тогда 
		ПоказатьПредупреждение(, Результат.ТекстПредупреждения);
	Иначе
		ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(Результат.АдресДанных, ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьПоясненияПоРазделам8_12(Команда)
	КонтекстЭДОКлиент.СоздатьПоясненияКДекларацииПоНДС(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПодготовитьПоясненияПоРазделам1_7(Команда)
	КонтекстЭДОКлиент.СоздатьПисьмоВОтветНаДокументРеализацииПолномочий(Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ОпределитьВидДокумента(КонтекстЭДОСервер)

	ЭтоТребованиеОПредставленииДокументов = 
		Объект.ВидДокумента = Перечисления.ВидыНалоговыхДокументов.ТребованиеОПредставленииДокументов;
		
	ЭтоТребованиеОПредставленииПоясненийКДекларацииНДС = 
		Объект.ВидДокумента = Перечисления.ВидыНалоговыхДокументов.ТребованиеОПредставленииПоясненийКДекларацииНДС;
		
	ЭтоТребованиеФНС = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЭтоТребованиеФНС(Объект.Ссылка);
		
	ЕстьТребованияКРазделам8_12 = КонтекстЭДОСервер.ЕстьТребованияКРазделам8_12(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭУ(КонтекстЭДОСервер)
	
	Заголовок = Справочники.ДокументыРеализацииПолномочийНалоговыхОрганов.НаименованиеДокументаРеализацииПолномочий(Объект.Ссылка);
	
	Элементы.Тема.Заголовок = Заголовок;
	Элементы.ТекстПисьма.Заголовок = "Приложенные файлы:";
	
	ПрорисоватьПриложения();
	
	ОписьВходящихДокументов = ДокументооборотСКОВызовСервера.ПолучитьОписьВходящихДокументовПоТребованию(Объект.Ссылка);
	
	Элементы.ГруппаСрокиПредставления.Видимость = ЭтоТребованиеФНС;
		
	Если ЭтоТребованиеОПредставленииПоясненийКДекларацииНДС Тогда
		
		Элементы.КомандаСоздатьОтвет.Заголовок = 
			НСтр("ru = 'Подготовить пояснения'");
		Элементы.ИнформацияСроки.Заголовок = 
			НСтр("ru = 'Ответ на требование должен быть направлен в течение 5 дней с момента получения'");
			
	КонецЕсли;
	
	// Если есть требования к разделу 8-12, тогда должно быть сразу два варианта ответа.
	// Если нет, то кнопка будет одна - создание неформализованного письма.
	ПоказыватьСразуДваВариантаОтвета = 
		ЭтоТребованиеОПредставленииПоясненийКДекларацииНДС
		И ЕстьТребованияКРазделам8_12;
	
	Элементы.ГруппаОтветовНаТребованиеПоДекларацииНДС.Видимость = ПоказыватьСразуДваВариантаОтвета;
	Элементы.КомандаСоздатьОтвет.Видимость = НЕ ПоказыватьСразуДваВариантаОтвета;
	
	Элементы.ЗапроситьСверку.Видимость =
		Объект.ВидДокумента = Перечисления.ВидыНалоговыхДокументов.ТребованиеОбУплатеНалогаСбораПениШтрафа;
		
	ПрорисоватьСтатус();
	
КонецПроцедуры

&НаСервере
Функция ПрорисоватьПриложения()
	
	ВсеВложенияТребования = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ПолучитьВложенияДокументовРеализацииПолномочийНалоговыхОрганов(Объект.Ссылка);
	
	Если ЭтоТребованиеОПредставленииПоясненийКДекларацииНДС Тогда
		// Не показываем xml-файлы, если это требование о представлении пояснений к декларации по НДС
		Для каждого ПриложениеТребования Из ВсеВложенияТребования Цикл
			
			СвойстваФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПриложениеТребования.ИмяФайла);
			
			Если ВРЕГ(СвойстваФайла.Расширение) <> ВРЕГ(".xml") Тогда
				Вложения.Добавить(ПриложениеТребования);
			КонецЕсли;
		
		КонецЦикла;
	Иначе
		Вложения.ЗагрузитьЗначения(ВсеВложенияТребования);
	КонецЕсли;
	
	Элементы.Вложения.Заголовок = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ФорматированноеПредставлениеСпискаВложений(Вложения.ВыгрузитьЗначения());
			
КонецФункции

&НаКлиенте
Процедура ПослеПодтвержденияПриемаИлиОтказаВПриеме(Результат, ВходящийКонтекст) Экспорт
	
	ПрорисоватьСтатус();
	
	// Перерисовываем другие формы при необходимости
	ОповеститьОбОкончанииОтправки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбОкончанииОтправки()
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Организация", Объект.Организация);
	ПараметрыОповещения.Вставить("Ссылка", 		Объект.Ссылка);
	
	Оповестить("Завершение отправки", ПараметрыОповещения, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросАктаСверкиРасчетов(Команда)
	
	КонтекстЭДОКлиент.СоздатьЗапросНаСверку(
		Объект.Организация, 
		ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеАктовСверкиРасчетов"));
		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросВыпискиОперацийИзКарточкиРасчетыСБюджетом(Команда)
	
	КонтекстЭДОКлиент.СоздатьЗапросНаСверку(
		Объект.Организация, 
		ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеВыпискиОперацийИзКарточкиРасчетыСБюджетом"));
		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросСпискаПредставленнойОтчетности(Команда)
	
	КонтекстЭДОКлиент.СоздатьЗапросНаСверку(
		Объект.Организация, 
		ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеПеречняБухгалтерскойИНалоговойОтчетности"));
		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросСправкиОбИсполненииОбязанностейПоУплате(Команда)
	
	КонтекстЭДОКлиент.СоздатьЗапросНаСверку(
		Объект.Организация, 
		ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеСправкиОбИсполненииОбязанностейПоУплате"));
		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗапросСправкиОСостоянииРасчетовСБюджетом(Команда)
	
	КонтекстЭДОКлиент.СоздатьЗапросНаСверку(
		Объект.Организация, 
		ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеСправкиОСостоянииРасчетовСБюджетом"));
		
КонецПроцедуры
