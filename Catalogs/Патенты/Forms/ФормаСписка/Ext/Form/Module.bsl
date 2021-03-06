﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Период = ?(ЗначениеЗаполнено(Параметры.Период), Параметры.Период, ОбщегоНазначения.ТекущаяДатаПользователя());
	
	ВидПериода  = Перечисления.ДоступныеПериодыОтчета.Год;
	НачалоПериода = НачалоГода(Период);
	КонецПериода  = КонецГода(Период);
	
	ОтборПериодИспользование = Истина;
	ОтборПериод = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(ВидПериода, НачалоПериода, КонецПериода);
	
	УстановитьОтборПоПериоду(ЭтотОбъект, НачалоПериода, КонецПериода, ОтборПериодИспользование);
	
	ОсновнаяОрганизация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	
	ОтборВладелец = ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект,,
		"Владелец");
	ОтборВладелецИспользование = ЗначениеЗаполнено(ОтборВладелец);
	Элементы.ГруппаОтборПоОрганизации.Видимость = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Патенты);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" И НЕ ЗначениеЗаполнено(ОтборВладелец) Тогда
		
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, "Владелец", Параметр);
	ИначеЕсли  ИмяСобытия = "ОбновитьФорму"
		И (ТипЗнч(Источник) = Тип("ДокументСсылка.ПлатежноеПоручение")
			ИЛИ ТипЗнч(Источник) = Тип("ДокументСсылка.РасходныйКассовыйОрдер")) Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПериодИспользованиеПриИзменении(Элемент)
	
	УстановитьОтборПоПериоду(ЭтотОбъект, НачалоПериода, КонецПериода, ОтборПериодИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ОтборПериод   = Формат(Число(ОтборПериод) + Направление, "ЧГ=");
	НачалоПериода = ДобавитьМесяц(НачалоПериода, 12*Направление);
	КонецПериода  = ДобавитьМесяц(КонецПериода, 12*Направление);
	
	УстановитьОтборПоПериоду(ЭтотОбъект, НачалоПериода, КонецПериода, ОтборПериодИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодОбработкаВыбора(
		Элемент, ВыбранноеЗначение, СтандартнаяОбработка,
		ВидПериода, ОтборПериод, НачалоПериода, КонецПериода);
	
	УстановитьОтборПоПериоду(ЭтотОбъект, НачалоПериода, КонецПериода, ОтборПериодИспользование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка,
		ВидПериода, ОтборПериод, НачалоПериода, КонецПериода);

КонецПроцедуры

&НаКлиенте
Процедура ПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ВыборПериодаКлиент.ПериодОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка,
		ВидПериода, ОтборПериод, НачалоПериода, КонецПериода);

КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборВладелецИспользование = ЗначениеЗаполнено(ОтборВладелец);
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Владелец");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Владелец");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Владелец");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если НЕ Копирование Тогда
		Отказ = Истина;
		
		ЗначенияЗаполнения = ОбщегоНазначенияБПВызовСервера.ЗначенияЗаполненияДинамическогоСписка(Список.КомпоновщикНастроек);
		Если ОтборПериодИспользование Тогда
			ЗначенияЗаполнения.Вставить("ДатаНачала",    НачалоПериода);
			ЗначенияЗаполнения.Вставить("ДатаОкончания", КонецПериода);
		КонецЕсли;
		
		ОткрытьФорму("Справочник.Патенты.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура ОплатитьБанк(Команда)
	
	Оплатить(Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьНаличными(Команда)
	
	Оплатить(Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявлениеНаПатент(Команда)
	
	СоздатьЗаявление(ПредопределенноеЗначение(
		"Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеПатентаРекомендованнаяФорма"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявлениеУтратаПраваНаПатент(Команда)
	
	СоздатьЗаявление(ПредопределенноеЗначение(
		"Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОбУтратеПраваНаПатент"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявлениеПрекращениеДеятельности(Команда)
	
	СоздатьЗаявление(ПредопределенноеЗначение(
		"Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПрекращенииДеятельностиПоПатентнойСистеме"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.КомпоновщикНастроек.ЗагрузитьФиксированныеНастройки(НастройкиОформленияСписка());
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НастройкиОформленияСписка()
	
	НастройкиКомпоновкиДанных = Новый НастройкиКомпоновкиДанных;
	
	МассивПолей = Новый Массив();
	МассивПолей.Добавить("ПервыйПлатеж");
	МассивПолей.Добавить("ВторойПлатеж");
	
	Сегодня = НачалоДня(ТекущаяДатаСеанса());
	Завтра = Сегодня + 24*60*60;
	ПустаяДата = Дата("00010101");
	
	Для каждого ИмяПоля из МассивПолей Цикл
		
		ДобавитьУсловноеОформлениеПоляПлатеж(НастройкиКомпоновкиДанных, ИмяПоля,
			Сегодня, Сегодня, НСтр("ru = 'Сегодня'"), ЦветаСтиля.ВажноеСобытие);
		
		ДобавитьУсловноеОформлениеПоляПлатеж(НастройкиКомпоновкиДанных, ИмяПоля,
			Завтра, Завтра, НСтр("ru = 'Завтра'"), ЦветаСтиля.ПриближающеесяСобытие);
			
		ДобавитьУсловноеОформлениеПоляДокументПлатеж(НастройкиКомпоновкиДанных, ИмяПоля);
		
		ДобавитьУсловноеОформлениеПоляПлатежВидимость(НастройкиКомпоновкиДанных, "Документ" + ИмяПоля,
			ИмяПоля+"Оплачен", Ложь);
		
		ДобавитьУсловноеОформлениеПоляПлатежВидимость(НастройкиКомпоновкиДанных, ИмяПоля,
			ИмяПоля+"Оплачен", Истина);
		
	КонецЦикла;
	
	ДобавитьУсловноеОформлениеПоляСуммаПерваыйПлатеж(НастройкиКомпоновкиДанных);
	
	ДобавитьУсловноеОформлениеСтрокиВторойПлатежВидимость(НастройкиКомпоновкиДанных);

	Возврат НастройкиКомпоновкиДанных;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ДобавитьУсловноеОформлениеПоляПлатежВидимость(НастройкиКомпоновкиДанных, ИмяПоля, ИмяПоляУсловия, ЗначениеСравнения)
	
	ЭлементУсловногоОформления = НастройкиКомпоновкиДанных.УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование  = Истина;
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяПоляУсловия);
	ЭлементОтбора.ПравоеЗначение = ЗначениеСравнения;
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно; 
	
	ЭлементПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Использование = Истина;
	ЭлементПоля.Поле          = Новый ПолеКомпоновкиДанных(ИмяПоля);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьУсловноеОформлениеПоляПлатеж(НастройкиКомпоновкиДанных, ИмяПоля, НижняяГраница, ВерхняяГраница, Текст, ЦветТекста = Неопределено)
	
	ЭлементУсловногоОформления = НастройкиКомпоновкиДанных.УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", Текст);
	
	Если ЦветТекста <> Неопределено Тогда
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветТекста);
	КонецЕсли;
	
	Если НижняяГраница <> Неопределено Тогда
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяПоля);
		ЭлементОтбора.ПравоеЗначение = НижняяГраница;
		ЭлементОтбора.ВидСравнения   = ?(НижняяГраница = ВерхняяГраница, 
			ВидСравненияКомпоновкиДанных.Равно, 
			ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
	КонецЕсли;
	
	Если ВерхняяГраница <> Неопределено 
		И НижняяГраница <> ВерхняяГраница Тогда
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование  = Истина;
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяПоля);
		ЭлементОтбора.ПравоеЗначение = ВерхняяГраница;
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	КонецЕсли;
	
	ЭлементПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Использование = Истина;
	ЭлементПоля.Поле          = Новый ПолеКомпоновкиДанных(ИмяПоля);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьУсловноеОформлениеПоляДокументПлатеж(НастройкиКомпоновкиДанных, ИмяПоля)
	
	ЭлементУсловногоОформления = НастройкиКомпоновкиДанных.УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", "Оплачен");
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(0,128,0));
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование  = Истина;
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяПоля+"Оплачен");
	ЭлементОтбора.ПравоеЗначение = Истина;
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно; 
	
	ЭлементПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Использование = Истина;
	ЭлементПоля.Поле          = Новый ПолеКомпоновкиДанных("Документ"+ИмяПоля);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьУсловноеОформлениеПоляСуммаПерваыйПлатеж(НастройкиКомпоновкиДанных)
	
	ЭлементУсловногоОформления = НастройкиКомпоновкиДанных.УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", "<не заполнено>");
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ГоризонтальноеПоложение", ГоризонтальноеПоложение.Право);
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование  = Истина;
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ПервыйПлатеж");
	ЭлементОтбора.ПравоеЗначение = Дата("00010101");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно; 
	
	ЭлементПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Использование = Истина;
	ЭлементПоля.Поле          = Новый ПолеКомпоновкиДанных("СуммаПервыйПлатеж");
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьУсловноеОформлениеСтрокиВторойПлатежВидимость(НастройкиКомпоновкиДанных)
	
	ЭлементУсловногоОформления = НастройкиКомпоновкиДанных.УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование  = Истина;
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВторойПлатеж");
	ЭлементОтбора.ПравоеЗначение = Дата("00010101");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно; 
	
	ЭлементПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Использование = Истина;
	ЭлементПоля.Поле          = Новый ПолеКомпоновкиДанных("ВторойПлатеж");
	
	ЭлементПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Использование = Истина;
	ЭлементПоля.Поле          = Новый ПолеКомпоновкиДанных("ДокументВторойПлатеж");
	
	ЭлементПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Использование = Истина;
	ЭлементПоля.Поле          = Новый ПолеКомпоновкиДанных("СуммаВторойПлатеж");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПериоду(Форма, НачалоПериода, КонецПериода, Использование)
	
	ОтборКомпоновкиДанных = Форма.Список.КомпоновщикНастроек.Настройки.Отбор;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		ОтборКомпоновкиДанных, "ДатаНачала");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ОтборКомпоновкиДанных, "ДатаНачала", НачалоПериода, ВидСравненияКомпоновкиДанных.БольшеИлиРавно, , Использование);
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		ОтборКомпоновкиДанных, "ДатаОкончания");
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ОтборКомпоновкиДанных, "ДатаОкончания", КонецПериода, ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, , Использование);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда

		Патент = ТекущиеДанные.Ссылка;
		Если Поле.Имя = "ДокументПервыйПлатеж" Тогда
			
			ПоказатьЗначение(,ТекущиеДанные.ДокументПервыйПлатеж);
			
		ИначеЕсли Поле.Имя = "ДокументВторойПлатеж"Тогда
			
			ПоказатьЗначение(,ТекущиеДанные.ДокументВторойПлатеж);
			
		Иначе
			
			ПоказатьЗначение(,Патент);
				
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Оплатить(ИмяКоманды)
	
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеПатента = ПолучитьДанныеПатента(ТД.Ссылка);

	Если ДанныеПатента.ОплаченПолностью Тогда
		ТекстПредупреждения = НСтр("ru = 'Патент ""%1"" на сумму %2 руб. оплачен полностью'");
		ПоказатьПредупреждение(, СтрШаблон(ТекстПредупреждения, ДанныеПатента.Наименование, ДанныеПатента.СуммаПлатежаПолного));
		Возврат;
	КонецЕсли;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Перед оплатой необходимо заполнить данные о патенте");
		Возврат;
	Иначе
		
		СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыУплатыНалогов.НаличнымиПоКвитанции");
		Если ИмяКоманды = "ОплатитьБанк" Тогда
			СпособОплаты = ПредопределенноеЗначение("Перечисление.СпособыУплатыНалогов.БанковскийПеревод");
		КонецЕсли;
		
		ДанныеПатента.Вставить("СпособОплаты", СпособОплаты);
		
		Если ЗначениеЗаполнено(ДанныеПатента.СписокПлатежей) Тогда
			
			ОбработкаОповещения = Новый ОписаниеОповещения("ОплатитьВыборЗавершение", ЭтотОбъект);
			ПараметрыФормы = Новый Структура("ДанныеПатента", ДанныеПатента);
			
			ОткрытьФорму("Справочник.Патенты.Форма.ФормаОплаты", ПараметрыФормы, ЭтотОбъект, УникальныйИдентификатор,,,ОбработкаОповещения);
		Иначе
			ОписаниеПараметровОплаты = ПолучитьОписаниеОплатыПатента(ДанныеПатента);
			ОткрытьФорму(ОписаниеПараметровОплаты.ИмяФормы, ОписаниеПараметровОплаты.ПараметрыФормы);
		КонецЕсли;
		
	КонецЕсли;
	
Конецпроцедуры

&НаКлиенте
Процедура ОплатитьВыборЗавершение(ДанныеПатента, ДополнительныеПараметры) Экспорт
	
	Если ДанныеПатента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеПараметровОплаты = ПолучитьОписаниеОплатыПатента(ДанныеПатента);
	ОткрытьФорму(ОписаниеПараметровОплаты.ИмяФормы, ОписаниеПараметровОплаты.ПараметрыФормы);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДанныеПатента(Патент)
	Возврат Справочники.Патенты.ДанныеПатента(Патент);
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьОписаниеОплатыПатента(ДанныеПатента)
	
	Возврат Справочники.Патенты.ОписаниеОплатыПатента(ДанныеПатента);
	
КонецФункции

&НаКлиенте
Процедура СоздатьЗаявление(ВидЗаявления)
	
	ПараметрыФормы = Новый Структура();
	
	Если ОтборВладелецИспользование
		И ЗначениеЗаполнено(ОтборВладелец) Тогда
		ПараметрыФормы.Вставить("Организация", ОтборВладелец);
	Иначе
		ПараметрыФормы.Вставить("Организация", ОсновнаяОрганизация);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("СформироватьФормуОтчетаАвтоматически", Истина);
	
	Если ВидЗаявления = ПредопределенноеЗначение(
		"Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПрекращенииДеятельностиПоПатентнойСистеме") Тогда
		
		ДанныеСписка = Элементы.Список.ТекущиеДанные;
		Если ДанныеСписка = Неопределено Тогда
			ПараметрыЗаполнения = Новый Структура("Патент", Неопределено);
		Иначе
			ПараметрыЗаполнения = Новый Структура("Патент", ДанныеСписка.Ссылка);
		КонецЕсли;
		
		ПараметрыФормы.Вставить("ПараметрыЗаполнения", ПараметрыЗаполнения);
		
	КонецЕсли;
	
	УчетПСНКлиент.ОткрытьФормуЗаявления(ВидЗаявления, ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

