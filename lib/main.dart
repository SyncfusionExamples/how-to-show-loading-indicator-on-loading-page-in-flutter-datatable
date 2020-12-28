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
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<Employee> _employees;

EmployeeDataSource _employeeDataSource = EmployeeDataSource();
List<Employee> paginatedDataSource = [];

class _MyHomePageState extends State<MyHomePage> {
  bool showLoadingIndicator = true;
  @override
  void initState() {
    super.initState();
    _employees = populateData();
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
                    rowsPerPage: 3,
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
          GridNumericColumn(mappingName: 'id', headerText: 'ID'),
          GridTextColumn(mappingName: 'name', headerText: 'Name'),
          GridTextColumn(mappingName: 'designation', headerText: 'Designation'),
          GridNumericColumn(mappingName: 'salary', headerText: 'Salary'),
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

class EmployeeDataSource extends DataGridSource<Employee> {
  @override
  List<Employee> get dataSource => paginatedDataSource;
  @override
  Object getValue(Employee employee, String columnName) {
    switch (columnName) {
      case 'id':
        return employee.id;
        break;
      case 'name':
        return employee.name;
        break;
      case 'salary':
        return employee.salary;
        break;
      case 'designation':
        return employee.designation;
        break;
      default:
        return ' ';
        break;
    }
  }

  @override
  int get rowCount => _employees.length;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex,
      int startRowIndex, int rowsPerPage) async {
    int endIndex = startRowIndex + rowsPerPage;
    if (endIndex > _employees.length) {
      endIndex = _employees.length - 1;
    }

    await Future.delayed(Duration(milliseconds: 2000));

    paginatedDataSource = List.from(
        _employees.getRange(startRowIndex, endIndex).toList(growable: false));
    notifyListeners();
    return true;
  }
}
