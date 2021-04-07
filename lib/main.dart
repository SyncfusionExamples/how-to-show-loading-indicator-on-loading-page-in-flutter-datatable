import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syncfusion DataGrid Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<Employee> paginatedDataSource = [];
List<Employee> _employees = [];
final int rowsPerPage = 10;

class _MyHomePageState extends State<MyHomePage> {
  late EmployeeDataSource _employeeDataSource;

  bool showLoadingIndicator = true;
  double pageCount = 0;

  @override
  void initState() {
    super.initState();
    _employees = populateData();
    _employeeDataSource = EmployeeDataSource();
    pageCount = (_employees.length / rowsPerPage).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PageNavigation Demo'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(children: [
            Column(
              children: [
                SizedBox(
                    height: constraints.maxHeight - 60,
                    width: constraints.maxWidth,
                    child: buildStack(constraints)),
                Container(
                  height: 60,
                  width: constraints.maxWidth,
                  child: SfDataPager(
                    pageCount: pageCount,
                    direction: Axis.horizontal,
                    onPageNavigationStart: (int pageIndex) {
                      setState(() {
                        showLoadingIndicator = true;
                      });
                    },
                    delegate: _employeeDataSource,
                    onPageNavigationEnd: (int pageIndex) {
                      setState(() {
                        showLoadingIndicator = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ]);
        },
      ),
    );
  }

  Widget buildDataGrid(BoxConstraints constraint) {
    return SfDataGrid(
        source: _employeeDataSource,
        columnWidthMode: ColumnWidthMode.fill,
        columns: <GridColumn>[
          GridTextColumn(
              columnName: 'id',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.center,
                  child: Text(
                    'ID',
                  ))),
          GridTextColumn(
              columnName: 'name',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.center,
                  child: Text('Name'))),
          GridTextColumn(
              columnName: 'designation',
              width: 110,
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.center,
                  child: Text(
                    'Designation',
                    overflow: TextOverflow.ellipsis,
                  ))),
          GridTextColumn(
              columnName: 'salary',
              label: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.center,
                  child: Text('Salary'))),
        ]);
  }

  Widget buildStack(BoxConstraints constraints) {
    List<Widget> _getChildren() {
      final List<Widget> stackChildren = [];
      stackChildren.add(buildDataGrid(constraints));

      if (showLoadingIndicator) {
        stackChildren.add(Container(
          color: Colors.black12,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
        ));
      }

      return stackChildren;
    }

    return Stack(
      children: _getChildren(),
    );
  }

  List<Employee> populateData() {
    return [
      Employee(10001, 'James', 'Project Lead', 20000),
      Employee(10002, 'Kathryn', 'Manager', 30000),
      Employee(10003, 'Lara', 'Developer', 15000),
      Employee(10004, 'Michael', 'Designer', 15000),
      Employee(10005, 'martin', 'Developer', 15000),
      Employee(10006, 'newberry', 'Developer', 15000),
      Employee(10007, 'Balnc', 'Project Lead', 25000),
      Employee(10008, 'Perry', 'Developer', 15000),
      Employee(10009, 'Gable', 'Designer', 10000),
      Employee(10010, 'Keefe', 'Project Lead', 25000),
      Employee(10011, 'Doran', 'Developer', 35000),
      Employee(10012, 'Linda', 'Designer', 19000),
      Employee(10013, 'Perry', 'Developer', 15000),
      Employee(10014, 'Gable', 'Designer', 10000),
      Employee(10015, 'Keefe', 'Project Lead', 25000),
    ];
  }
}

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);

  final int id;

  final String name;

  final String designation;

  final int salary;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource() {
    paginatedDataSource = _employees.getRange(0, 10).toList();
    buildDataGridRows();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    await Future.delayed(const Duration(seconds: 3));
    int startIndex = newPageIndex * rowsPerPage;
    int endIndex = startIndex + rowsPerPage;
    if (startIndex < _employees.length) {
      if (endIndex > _employees.length) {
        endIndex = _employees.length;
      }
      paginatedDataSource =
          _employees.getRange(startIndex, endIndex).toList(growable: false);
      buildDataGridRows();
    } else {
      paginatedDataSource = [];
    }
    notifyListeners();
    return true;
  }

  void buildDataGridRows() {
    _employeeData = paginatedDataSource
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(
                  columnName: 'designation', value: e.designation),
              DataGridCell<int>(columnName: 'salary', value: e.salary),
            ]))
        .toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
