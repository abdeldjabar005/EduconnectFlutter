import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/features/random_quote/presentation/cubit/random_quote_cubit.dart';
import '../widgets/quote_content.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  _getRandomQuote() =>
      BlocProvider.of<RandomQuoteCubit>(context).getRandomQuote();

  @override
  void initState() {
    super.initState();
    _getRandomQuote();
  }

  Widget _buildBodyContent() {
    return BlocBuilder<RandomQuoteCubit, RandomQuoteState>(
        builder: (context, state) {
      if (state is RandomQuoteIsLoading) {
        return Center(
          child: SpinKitFadingCircle(
            color: AppColors.primary,
          ),
        );
      } else if (state is RandomQuoteError) {
        return const Text('error');
      } else if (state is RandomQuoteLoaded) {
        return Column(
          children: [
            QuoteContent(
              quote: state.quote,
            ),
            InkWell(
                onTap: () => _getRandomQuote(),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.primary),
                  child: const Icon(
                    Icons.refresh,
                    size: 28,
                    color: Colors.white,
                  ),
                ))
          ],
        );
      } else {
        return Center(
          child: SpinKitFadingCircle(
            color: AppColors.primary,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text("name"),
    );
    return RefreshIndicator(
        child: Scaffold(
          appBar: appBar,
          body: _buildBodyContent(),
        ),
        onRefresh: () => _getRandomQuote());
  }
}
