import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:my_camp/logic/blocs/campsite_event/campsite_event_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class AddProductPage extends StatefulWidget {
  final String campsiteId;
  const AddProductPage({super.key, required this.campsiteId});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  late CampsiteEventBloc _campsiteEventBloc;

  @override
  void initState() {
    super.initState();
    _campsiteEventBloc = context.read<CampsiteEventBloc>();
    _startDateController.text = '-';
    _endDateController.text = '-';
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    final date = PickerDateRange(args.value.startDate, args.value.endDate);
    DateFormat formatter = DateFormat('dd-MM-yyyy');

    _startDateController.text = formatter.format(date.startDate!);
    _endDateController.text =
        date.endDate == null ? '-' : formatter.format(date.endDate!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16.0),
                    const Text(
                      'Select event\'s date range',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SfDateRangePicker(
                      onSelectionChanged: _onSelectionChanged,
                      enablePastDates: false,
                      selectionMode: DateRangePickerSelectionMode.range,
                    ),
                    TextFormField(
                      controller: _startDateController,
                      readOnly: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == '-' || value == null || value.isEmpty) {
                          return 'Please select a start date';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                      ),
                    ),
                    TextFormField(
                      controller: _endDateController,
                      readOnly: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == '-' || value == null || value.isEmpty) {
                          return 'Please select an end date';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a name';
                        }
                        if (value.length > 20) {
                          return 'Name must be at most 20 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Event Name',
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.parse(
                                value.replaceAll(r',', '').split(' ')[1]) <
                            0.01) {
                          return 'Please enter a price at least RM 0.01';
                        }
                      },
                      controller: _priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        CurrencyInputFormatter(
                            leadingSymbol: 'RM ',
                            thousandSeparator: ThousandSeparator.Comma,
                            mantissaLength: 2)
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Total Price Amount',
                        hintText: '0.00',
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            double price = double.parse(_priceController.text
                                    .replaceAll(r',', '')
                                    .split(' ')[1]) *
                                100;
                            _campsiteEventBloc.add(
                              CampsiteEventAdd(
                                name: _nameController.text,
                                startDate: DateFormat("dd-MM-yyyy")
                                    .parse(_startDateController.text)
                                    .toLocal(),
                                endDate: DateFormat("dd-MM-yyyy")
                                    .parse(_endDateController.text)
                                    .toLocal(),
                                price: price.toInt(),
                                campsiteId: widget.campsiteId,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        label: const Text('Add'),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
